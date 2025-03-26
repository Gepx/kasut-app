import 'package:flutter/material.dart';
import '../../models/blog_model.dart';

class BlogDetail extends StatelessWidget {
  final BlogPost post;

  const BlogDetail({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('Blog Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image
            Image.asset(
              post.images.first,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Author and date
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(post.authorImage),
                        radius: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${post.publishTime.day}/${post.publishTime.month}/${post.publishTime.year}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Content
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        letterSpacing: 0.5,
                        color: Colors.black, // Make sure text is visible
                      ),
                      children:
                          post.content
                              .split('\n\n') // Split into paragraphs
                              .map(
                                (paragraph) => TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: SizedBox(
                                        width: 24.0,
                                      ), // Indent size
                                    ),
                                    TextSpan(text: paragraph.trim()),
                                    TextSpan(
                                      text: '\n\n',
                                    ), // Add spacing between paragraphs
                                  ],
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
