echo "Building PetPet and installing to WoW directory."

touch PetPet.toc.tmp

cat PetPet.toc > PetPet.toc.tmp

sed -i "s/@project-version@/$(git describe --abbrev=0)/g" PetPet.toc.tmp

mkdir -p /h/games/World\ of\ Warcraft/_classic_/Interface/AddOns/PetPet/

cp *.lua /h/games/World\ of\ Warcraft/_classic_/Interface/AddOns/PetPet/

cp PetPet.toc.tmp /h/games/World\ of\ Warcraft/_classic_/Interface/AddOns/PetPet/PetPet.toc

rm PetPet.toc.tmp

echo "Complete."