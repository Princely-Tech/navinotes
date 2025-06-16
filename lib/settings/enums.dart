enum ImagePlaceHolderTypes {
  asset,
  network;

  bool get isAsset => this == ImagePlaceHolderTypes.asset;
  bool get isNetwork => this == ImagePlaceHolderTypes.network;
}

enum PageDisplayFormat {
  grid,
  list;

  bool get isGrid => this == PageDisplayFormat.grid;
  bool get isList => this == PageDisplayFormat.list;
}