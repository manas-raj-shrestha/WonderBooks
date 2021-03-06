import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/models/book.dart';
import '../../detail/book_detail.dart';

class BookListTile extends StatelessWidget {
  final Book book;

  const BookListTile(this.book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return BookDetail(book);
        }));
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            CachedNetworkImage(
              imageUrl: book.imgUrl,
              height: 150.h,
              fit: BoxFit.fitHeight,
              width: 100.w,
            ),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        'by ${book.author}',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        book.price,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ]),
              ),
            ),
            SizedBox(
              width: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}
