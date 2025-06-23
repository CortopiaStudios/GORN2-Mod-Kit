# GORN2-Mod-Kit
The official mod kit for the VR game GORN2

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

## Examples
There are a couple of example "mods" in the project under Assets/Examples/. Most of the examples contain a README-file describing details of how the mod can be exported and what is possible to do.

Various guideline documents are also included under the folder Assets/Guidelines/.

## Referencing core game assets inside a mod

## Physics materials

## Shaders

## Overriding existing assets

## Adding custom weapons

## Adding custom armors

## Adding custom 

## Further reading
### Guideline documents
