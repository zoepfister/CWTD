## Create new inherited scene from `scene/levels/level_base.tscn`

![create_inherited_scene](images/{1F41FEA8-C74F-448F-8110-1DDF3419BFCA}.png)

## Save scene into a separate folder under `scenes/levels`

![save_scene](images/{96305BAB-8619-4173-AE50-6443E4A4D406}.png)

Remember to rename the new scene

## Create the level

Initially the scene will have all the elements placed in the origin.
A scene by default will have:

- A goal
- A fire instance
- A death zone
- A spawn point
- 3 TileMapLayers
  - Background
  - Indestructible
  - Destructible

The proper tilesets are properly configured in the parent scene.

This is how the inherited scene will look initially:

![base_level_layout](images/{2D02E1B8-4F42-4981-A51F-35CE6B1ACA0F}.png)

And here is an example of a concrete level

![simple_level](images/simple_level.png)
