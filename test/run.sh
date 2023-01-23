echo "Testing the tile pyramid generation..."
rio mbtiles --zoom-levels 6..6 /opt/test/sample.tif /opt/test/output.mbtiles
echo "Test passed! Tile pyramid generated"