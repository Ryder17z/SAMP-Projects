# TODO's and issues

##### This is a collection of issues and things that should be added or improved.

### Testing required

* Meeleattacks on trains
* Implementation as a filterscript

### Optional fix for airplane shapes

>Because of their strange shapes, the polygon area used in the script is not efficient.
> The function that needs a fix is inside FindVehicleNearPlayer.inc
> Currently all vehicles are treated as a 2D box, This is not a good idea for the airplanes however.
>  
> For the planes, there needs to be extra polygon data to override this box issue, here is a visual representation of the problem:

![plane_issue](https://github.com/Ryder17z/SAMP-Projects/blob/main/CustomVehicleDamage/plane_issue.png)

> There is also an issue with the height of the wings when they sit high enough that players can walk under them. This is a limitation of the 2D Polygon check so for big planes.
There should be an additional check between the player's Zpos and the height of the wing, if the difference is higher than 1 unit (gta:sa is metric) then the code should return 0 because because they aren't really close enough to cause damage using melee weapons

> Perhaps this could be done with a hierarchy of simple areas instead of a complex polygon (similar to how collisions are handled in most engines). The body could be a long cuboid and the wings could be a flat cuboid. Or, it could be done on a per-model basis where the wings are completely ignored for large planes and a diamond shape is used for smaller ones (with each point of the diamond being at the wing tips, nose and tail).

> another way to solve this is just to use 3 areas for big planes: one for the main hull and one for each big wing. Area overlapping might/should be taken into consideration however, so we only count each valid hit once.

### Miscellaneous

> Probably needs a standard include-guard:

```pawn
#if defined CUSTOM_VEHICLE_DAMAGE_INC
    >#endinput
#else
    #define CUSTOM_VEHICLE_DAMAGE_INC
#endif
```

