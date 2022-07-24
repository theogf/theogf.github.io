using DitherPunk
using Images
using Images.ImageTransformations

save("_assets/dithered_profile.png", dither(imresize(RGB.(load("_assets/profile.png")), ratio=1/2), Bayer()))