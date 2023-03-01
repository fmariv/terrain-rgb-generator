# Terrain RGB generator

Tool that allows to easily deploy an environment able to work with geotiff files containing Digital Elevation Model (DEM) data. It is focused on the generation of raster MBTiles pyramids, containing a [Mapbox Terrain-RGB](https://docs.mapbox.com/help/troubleshooting/access-elevation-data/) tileset with the elevation data encoded in Terrain-RGB tiles. Those tiles can be used to represent the topographic surface of the Earth.

## Usage

### Set up 

First of all, there are some environment variables that need to be established in the ```.env``` file, which are the following:

```
MIN_ZOOM           # min zoom to generate
MAX_ZOOM           # max zoom to generate
INPUT_FILE         # name of the input raster file
OUTPUT_FILE        # name of the output mbtiles file
WORKERS            # workers to run [DEFAULT=4]
```

Also, you can ask for a help message if you need
```shell
make help
```

### Build
To work with this tool you need Docker.

- Install [Docker](https://docs.docker.com/engine/installation/). Minimum version is 1.12.3+.

The docker image is based on ```osgeo/gdal```. For the raster data management, [rasterio](https://rasterio.readthedocs.io/en/latest/) and a few plugins from the [RasterIO Plugin Registry](https://github.com/mapbox/rasterio/wiki/Rio-plugin-registry), such as rio-mbtiles and a custom and powered version of [rio-rgbify](https://github.com/fmariv/rio-rgbify), are installed.

Then, you can build the container from the dockerfile
```shell
make build-docker
```

Or simply run it using the image from the [Docker Hub](https://hub.docker.com/r/franmartin/terrain-rgb-generator) as follows.

### Generate pyramid
By default, it is generated in the data directory. 
```shell
make generate-pyramid-rgb
```

### Custom
You can run a bash shell inside the docker container if you want to run some more detailed commands
```shell
make bash
```

## Considerations

If you are wondering the resolution per **zoom**, check the following table.

Arc resolution per **zoom** and data sources, per pixel:

zoom   | meters at equator     | arc seconds     | nominal arc degrees minutes seconds            | nominal ground units
-----  | ---------- | -------- | ------------------- |  --------------------
**0**  | _156543.0_ | `5071.0` | **1.5 arc degrees**  |
**1**  | _78271.5_  | `2535.5` | **40 arc minutes**   |
**2**  | _39135.8_  | `1267.8` | **20 arc minutes**   |
**3**  | _19567.9_  | `633.9`  | **10 arc minutes**   |
**4**  | _9783.9_   | `316.9`  | **5 arc minutes**    |
**5**  | _4892.0_   | `158.5`  | **2.5 arc minutes**  |
**6**  | _2446.0_   | `79.2`   | **1 arc minutes**    | 2.5 km
**7**  | _1223.0_   | `39.6`   | **30 arc seconds**   | 1km 
**8**  | _611.5_    | `19.8`   | **15  arc seconds**  | 500m
**9**  | _305.7_    | `9.9`    | **7.5  arc seconds** | 250m
**10** | _152.9_    | `5.0`    | **5 arc seconds**    |
**11** | _76.4_     | `2.5`    | **3 arc seconds**    | 90m
**12** | _38.2_     | `1.2`    | **1 arc seconds**    | 30m
**13** | _19.1_     | `0.6`    | **2/3 arc seconds**  | 
**14** | _9.6_      | `0.3`    | **1/3 arc seconds**  | 10m
**15** | _4.8_      | `0.2`    | **1/5 arc seconds**  | 
**16** | _2.4_      | `0.1`    | **1/9 arc seconds**  | 3m

Credits: [Mapzen documentation](https://github.com/tilezen/joerd/edit/master/docs/data-sources.md).

## Author
Fran Martín

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
