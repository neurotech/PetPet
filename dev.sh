echo "Building PetPet and installing to WoW directory."

echo "Creating TOC file..."
touch PetPet.toc.tmp
cat PetPet.toc >PetPet.toc.tmp
sed -i "s/@project-version@/$(git describe --abbrev=0)/g" PetPet.toc.tmp

echo "Copying assets to Classic PTR..."
mkdir -p /c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_classic_ptr_/Interface/AddOns/PetPet/
cp *.lua /c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_classic_ptr_/Interface/AddOns/PetPet/
cp PetPet.toc.tmp /c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_classic_ptr_/Interface/AddOns/PetPet/PetPet.toc

echo "Copying assets to Retail PTRs..."
mkdir -p /c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_xptr_/Interface/AddOns/PetPet/
cp *.lua /c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_xptr_/Interface/AddOns/PetPet/
cp PetPet.toc.tmp /c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_xptr_/Interface/AddOns/PetPet/PetPet.toc

mkdir -p /c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_ptr_/Interface/AddOns/PetPet/
cp *.lua /c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_ptr_/Interface/AddOns/PetPet/
cp PetPet.toc.tmp /c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_ptr_/Interface/AddOns/PetPet/PetPet.toc

echo "Cleaning up..."
rm PetPet.toc.tmp

echo "Complete."
