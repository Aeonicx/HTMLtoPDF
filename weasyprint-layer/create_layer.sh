
#!/bin/bash
RUNTIME="python3.8"
ECHO $RUNTIME

mkdir -p build
docker run --rm \
	    -e INSTALL_MS_FONTS="${INSTALL_MS_FONTS}" \
	    -v `pwd`/fonts:/out \
	    -t lambci/lambda:build-${RUNTIME} \
	    bash /out/layer_builder.sh
mv -f fonts/layer.zip ./build/fonts-layer.zip

docker run --rm \
	    -v `pwd`/weasyprint:/out \
	    -t lambci/lambda:build-${RUNTIME} \
	    bash /out/layer_builder.sh
	mv -f ./weasyprint/layer.zip ./build/weasyprint-no-fonts-layer.zip
	cd build && rm -rf ./opt && mkdir opt \
	    && unzip fonts-layer.zip -d opt \
	    && unzip weasyprint-no-fonts-layer.zip -d opt \
	    && cd opt && zip -r9 ../weasyprint-layer-${RUNTIME}.zip .
#pwd
#ls -lah
echo "Layer created and ready to use: weasyprint-layer.zip "
mv -f ../weasyprint-layer-${RUNTIME}.zip ../../weasyprint-layer.zip




