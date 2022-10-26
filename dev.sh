echo "Building PetPet and installing to WoW directory."

echo "Creating TOC file..."
touch PetPet.toc.tmp
cat PetPet.toc > PetPet.toc.tmp
sed -i "s/@project-version@/$(git describe --abbrev=0)/g" PetPet.toc.tmp

echo "Copying assets..."
mkdir -p /h/games/World\ of\ Warcraft/_classic_/Interface/AddOns/PetPet/
cp *.lua /h/games/World\ of\ Warcraft/_classic_/Interface/AddOns/PetPet/
cp -r Textures /h/games/World\ of\ Warcraft/_classic_/Interface/AddOns/PetPet/
cp -r Elements /h/games/World\ of\ Warcraft/_classic_/Interface/AddOns/PetPet/
cp PetPet.toc.tmp /h/games/World\ of\ Warcraft/_classic_/Interface/AddOns/PetPet/PetPet.toc

echo "Cleaning up..."
rm PetPet.toc.tmp

echo "Complete."