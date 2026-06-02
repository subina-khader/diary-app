enum Templates {
  plain,
  topImage,
  doubleTopImage,
  bottomImage,
  doubleBottomImage,
  leftImage,
  rightImage,
  images,

}

class TemplateModel {
  final int maxImage;
  final Templates templateType;
  TemplateModel({required this.maxImage,required this.templateType});
}