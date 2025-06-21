enum ImagePlaceHolderTypes {
  asset,
  network;

  bool get isAsset => this == asset;
  bool get isNetwork => this == network;
}

enum PageDisplayFormat {
  grid,
  list;

  bool get isGrid => this == grid;
  bool get isList => this == list;
}
