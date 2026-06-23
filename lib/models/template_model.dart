enum Templates {
  plain,
  topMedia,
  doubleTopMedia,
  bottomMedia,
  doubleBottomMedia,
  leftMedia,
  rightMedia,
  medias,

}

class TemplateModel {
  final int maxImage;
  final Templates templateType;
  TemplateModel({required this.maxImage,required this.templateType});
}