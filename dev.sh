#!/bin/bash

WOW_DIR="/mnt/c/Program Files (x86)/World of Warcraft"
ADDON_NAME="PetPet"

TARGETS=(
    "_retail_:Retail"
    # "_classic_:Classic"
    # "_classic_ptr_:Classic PTR"
    # "_xptr_:Retail PTR (xptr)"
    # "_ptr_:Retail PTR"
)

install_addon() {
    local client="$1"
    local label="$2"
    local dest="$WOW_DIR/$client/Interface/AddOns/$ADDON_NAME"

    echo "Copying assets to $label..."
    mkdir -p "$dest"
    cp *.lua "$dest/"
    cp $ADDON_NAME.toc.tmp "$dest/$ADDON_NAME.toc"
}

echo "Building $ADDON_NAME and installing to WoW directory."

echo "Creating TOC file..."
sed "s/@project-version@/$(git describe --abbrev=0)/g" $ADDON_NAME.toc > $ADDON_NAME.toc.tmp

for target in "${TARGETS[@]}"; do
    client="${target%%:*}"
    label="${target##*:}"
    install_addon "$client" "$label"
done

echo "Cleaning up..."
rm $ADDON_NAME.toc.tmp

echo "Complete."
