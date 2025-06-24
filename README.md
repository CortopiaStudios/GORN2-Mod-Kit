# GORN2-Mod-Kit
The official mod kit for the VR game GORN2.

## How to export a mod
1. Mark the assets you want to export as [addressable](https://docs.unity3d.com/Packages/com.unity.addressables@0.4/manual/AddressableAssetsGettingStarted.html).
2. Switch to either Windows or Android in [Build Settings](https://docs.unity3d.com/2022.3/Documentation/Manual/BuildSettings.html) depending on what platform the mod should target.
3. Build the mod to a zip file using Mod Tools -> Build.
4. Find the zip-file in the explorer (follow the link printed in the [Console window](https://docs.unity3d.com/2022.3/Documentation/Manual/Console.html))
5. Upload the zip-file to you mod for [GORN2 in Modio](https://mod.io/g/gorn-2) (make sure to upload the zip-file to the correct platform).
6. Build the addressable group with the Default Build Script
7. Find the files at the build location ([Project]/ServerData/[Platform/) and zip them
8. Upload the zip file to the mod in modio
9. Activate the mod in the Modio menu inside the game.

## Limitations
### Custom scripts
Custom scripts cannot be exported in mods. Instead we recommend using the various behaviour tree components that exist in the project to create complex behaviors. Also, the different "reactive"-components can be used to hook up properties between objects to create custom behaviors.

## Example mods
There are a couple of example mods in the project under `Assets/Examples/`. Most of the examples contain README-files with details of how mods can be exported and things that can be done with mods.

Various guideline documents are also included under the folder `Assets/Guidelines/`.

## Adding custom weapons
It's possible to create custom weapons that are selectable in the Custom Mode weapons menu. Create a prefab for the weapon (currently it's recommended to see how existing weapons are implemented, for example `Assets/Cortopia/Prefabs/Weapons/BoneClub.prefab`), mark it as an addressable with the addressable label `Weapon` to make it appear in Custom Mode.

Add the component `ObjectDescrption` in the root object in the prefab to give the weapon a specific sprite that will be shown in the Custom Mode weapons menu. The name that will be shown is the name of the prefab.

## Adding custom armors

Custom armors will appear in the Custom Mode menu where the player can toggle what armor sets the enemies in the game should spawn with. Similar to custom weapons, create a prefab for the armor set (see `Assets/Cortopia/Prefabs/Armor/ArmorSet_Iron.prefab` how armor sets are implemented in the game), mark it as an addressable with the addressable label `Armor` to make it appear in Custom Mode.

Add the component `ObjectDescrption` in the root object in the prefab to give the armor a spefific sprite that will be shown in the Custom Mode menu. The name that will be shown is the name of the prefab.

## Referencing core game assets inside a mod

## Using GORN2 physic materials
Physic material assets from the core game are included in the mod kit project. They are used for not only controlling how the objects behave in the physics engine but also selecting the correct VFX's and sounds on collisions, determine if objects are penetrable by the `Piercing` component and other things.

To use the included physic materials with their other properties, you need to reference these assets as "addressables" and not use direct referencing, for example using the materials directly in `Collider` components. Otherwise, when exporting the mod, the assets will be copied resulting in their own unique objects that aren't recognized in the core game when for example playing collision VFX's, etc. The mod kit includes the component `ColliderMaterialReference` which is put on game objects with colliders to set the collider material using physic materials as "addressables" references. When exporting the mod the `ColliderMaterialReference` will use the correct material material in the game.

## Shaders

## Overriding existing assets

## Further reading
### Guideline documents
