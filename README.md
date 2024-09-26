
# AWS Lambda Function with WeasyPrint layer (python 3.8 preferred)

If you have a python app that uses WeasyPrint and you want to use it with AWS Lambda, you need to create a package that contains requirements. You can use this script to create an AWS Lambda layer package and upload it directly as Layer.


# Build Lambda Layer
Run cd weasyprint-layer
Run sh create_layer.sh to build weasyprint layer.

You can deploy layer with this command. (Requires AWS CLI)

    $ aws lambda publish-layer-version \
      --region "region_name" \
      --layer-name "weasyprint-layer" \
      --zip-file fileb://weasyprint-layer.zip
    

Environment variables expected by layer:

    GDK_PIXBUF_MODULE_FILE="/opt/lib/loaders.cache"
    FONTCONFIG_PATH="/opt/fonts"
    XDG_DATA_DIRS="/opt/lib"

You have to add environment variables to template.yml or add directly to Lambda function.

      Environment:
        Variables:
          GDK_PIXBUF_MODULE_FILE: "/opt/lib/loaders.cache"
          FONTCONFIG_PATH: "/opt/fonts"
          XDG_DATA_DIRS: "/opt/lib"

# Step 1:

aws lambda publish-layer-version \
      --region "region_name" \
      --layer-name "weasyprint-layer" \
      --zip-file fileb://weasyprint-layer.zip


# Step 2:

Update zappa setting json file - bucket name, layer arn and aws_region

# Step 3:

Zappa deploy/update

# Step 4:

aws lambda update-function-configuration \
    --function-name "htmltopdf-dev" \
    --environment Variables="{GDK_PIXBUF_MODULE_FILE=/opt/lib/loaders.cache,FONTCONFIG_PATH=/opt/fonts,XDG_DATA_DIRS=/opt/lib}"

# Step 5:

curl -X POST https://xxxxx.execute-api.eu-central-1.amazonaws.com/dev/convert \
     -H "Content-Type: application/json" \
     -d '{"html": ""}'



