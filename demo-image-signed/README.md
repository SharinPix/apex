# Generating signed url to display images :

In order to generate a signed token you will need a SharinPix Secret.
In this example we are using these parameters :

Secret id : 3e31e686-454f-400c-884e-c8e3910ce50d
SECRET Secret : XXXXXX
SharinPix Image id : e2fc0874-b0ed-4109-b105-72cc926265a5

Full reference of structure of the JWT token :

{
  "iss": "3e31e686-454f-400c-884e-c8e3910ce50d"
  "id": "e2fc0874-b0ed-4109-b105-72cc926265a5",
  "sharinpix": {
    "original": true,
    "download": true,
    "annotation": true,
    "crop": true,
    "rotation": true,
    "full_size": true,
  },
  "transformations": [ {
      "width": 300,
      "height": 200,
      "crop": "fill"
      "angle": 90,
    },
    {
      "overlay": "<sharinpix-id>",
      "flags": "tiled",
    }
  ]
}

Values for crop are : fill|fit|scale|pad

Then you can generate a link like this by generating the JWT token with the
secret secret as signature.

Here is an example (you can copy and paste the token to JWT.io for testing) :

https://pix.sharinpix.com/images/e2fc0874-b0ed-4109-b105-72cc926265a5?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIzZTMxZTY4Ni00NTRmLTQwMGMtODg0ZS1jOGUzOTEwY2U1MGQiLCJpZCI6ImUyZmMwODc0LWIwZWQtNDEwOS1iMTA1LTcyY2M5MjYyNjVhNSIsInRyYW5zZm9ybWF0aW9ucyI6W3sid2lkdGgiOjEwMCwiaGVpZ2h0IjoxMDAsImNyb3AiOiJmaXQifV19.vfkUGr-D17kS3Bq4IKh2ozg1LKNNexrOF71wnudTNC8
