class OnboardingItemModel {
  final String step;
  final String image;
  final String title;
  final String subtitle;
  final String description;
  final String buttonText;
  final List<String>? badges;

  const OnboardingItemModel({
    required this.step,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonText,
    this.badges,
  });

  static const List<OnboardingItemModel> items = [
    OnboardingItemModel(
      step: '01',
      image: 'assets/image/on_boarding.png',
      title: 'الإيمان للأعلاف',
      subtitle: 'خبرة في صناعة الأعلاف',
      description:
          'منذ عام 1990، نقدم حلولًا متخصصة في تغذية الدواجن والمواشي والأرانب والبط، مع اهتمام مستمر بجودة الخامات ودقة التصنيع.',
      buttonText: 'اكتشف منتجاتنا',
    ),
    OnboardingItemModel(
      step: '02',
      image: 'assets/image/on_boarding2.png',
      title: 'كل احتياجاتك في مكان واحد',
      subtitle: 'اختار العلف المناسب',
      description:
          'اكتشف مجموعة متنوعة من أعلاف الدواجن والمواشي والأرانب والبط، واختر المنتج المناسب لاحتياجات مزرعتك.',
      buttonText: 'تصفح المنتجات',
      badges: ['دواجن', 'مواشي', 'أرانب', 'بط'],
    ),
    OnboardingItemModel(
      step: '03',
      image: 'assets/image/on_boarding3.png',
      title: 'جودة تثق بها',
      subtitle: 'عناية في كل خطوة',
      description:
          'نهتم بجودة الخامات ودقة مراحل التصنيع والرقابة على المنتج، لنقدم أعلافًا تلبي احتياجات المربي.',
      buttonText: 'اعرف المزيد',
    ),
    OnboardingItemModel(
      step: '04',
      image: 'assets/image/on_boarding4.png',
      title: 'اطلب علفك بسهولة',
      subtitle: 'اختار، اطلب، وتابع',
      description:
          'تصفح المنتجات، اعرف تفاصيل كل منتج، اختر الكمية المناسبة وأكمل طلبك بسهولة من خلال التطبيق.',
      buttonText: 'ابدأ التسوق',
    ),
  ];
}
