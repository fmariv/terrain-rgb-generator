FROM osgeo/gdal:ubuntu-small-latest
ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
## install rio and a custom rio-rgbify build
RUN apt-get -y update && apt-get install -y python3-pip && apt-get install -y git \
    && pip3 install rasterio \
    && pip3 install rio-mbtiles \
    && git clone https://github.com/fmariv/rio-rgbify.git \
    && cd rio-rgbify \
    && pip install -e '.[test]' \
    && apt-get clean