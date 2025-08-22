import 'package:flutter/material.dart';
import 'package:inner_me_application/core/style.dart';

class SlideTextAnimatedPage extends StatefulWidget {
  @override
  _SlideTextAnimatedPageState createState() => _SlideTextAnimatedPageState();
}

class _SlideTextAnimatedPageState extends State<SlideTextAnimatedPage> {
  final PageController _controller = PageController();
  final List<String> texts = [
    'Bạn có nghe thấy không?\nĐã bao lâu rồi bạn chưa trò chuyện với chính mình...',
    'Chúng ta thường đi qua những ngày buồn mà chẳng kịp gọi tên cảm xúc.\nNhững câu hỏi bị bỏ quên, những cảm xúc chưa từng được lắng nghe ...',
    'Bạn sẵn sàng chưa?\nChuyến phiêu lưu vào nội tâm đang chờ bạn mở trang đầu tiên',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homepage/slide-1.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: PageView.builder(
          controller: _controller,
          itemCount: texts.length + 1,
          itemBuilder: (context, index) {
            final bool isLastPage = index == texts.length;
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double value = 1.0;
                if (_controller.position.haveDimensions) {
                  value = _controller.page! - index;
                  value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                }
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(50 * (1 - value), 0), // trượt ngang nhẹ
                    child: Builder(
                      builder: (context) {
                        if (!isLastPage) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Inner Me',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: IMAppColor.appWhite,
                                      fontSize: 30,
                                    ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                texts[index],
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: IMAppColor.appWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Inner Me',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: IMAppColor.appWhite,
                                      fontSize: 30,
                                    ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Bạn sẵn sàng chưa?',
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: IMAppColor.appWhite),
                              ),
                              Text(
                                'Chuyến phiêu lưu vào nội tâm đang chờ bạn mở trang đầu tiên',
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: IMAppColor.appWhite),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),

                              FilledButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: IMAppColor.appGrey,
                                      width: 1,
                                    ),
                                  ),
                                  backgroundColor: IMAppColor.appWhite,
                                  padding: EdgeInsets.zero,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Mở nhật ký',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: IMAppColor.appBlack,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),

                              FilledButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: IMAppColor.appGrey,
                                      width: 1,
                                    ),
                                  ),
                                  backgroundColor: IMAppColor.appWhite,
                                  padding: EdgeInsets.zero,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'Phát nhạc',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: IMAppColor.appBlack,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
