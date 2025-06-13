enum ImagePlaceHolderTypes {
  asset,
  network;

  bool get isAsset => this == ImagePlaceHolderTypes.asset;
  bool get isNetwork => this == ImagePlaceHolderTypes.network;
}
