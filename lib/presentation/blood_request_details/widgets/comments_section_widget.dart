import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget for comments section with real-time messaging
class CommentsSectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> comments;
  final Function(String)? onAddComment;
  final bool isLoading;

  const CommentsSectionWidget({
    super.key,
    required this.comments,
    this.onAddComment,
    this.isLoading = false,
  });

  @override
  State<CommentsSectionWidget> createState() => _CommentsSectionWidgetState();
}

class _CommentsSectionWidgetState extends State<CommentsSectionWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comments & Questions',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.comments.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Comment input
          _buildCommentInput(context),

          SizedBox(height: 3.h),

          // Comments list
          if (widget.comments.isEmpty)
            _buildEmptyState(context)
          else
            Column(
              children: widget.comments
                  .map((comment) => _buildCommentCard(context, comment))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: _commentController,
            focusNode: _commentFocusNode,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Ask a question or leave a comment...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Be respectful and helpful',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              ElevatedButton(
                onPressed:
                    _commentController.text.trim().isEmpty || widget.isLoading
                        ? null
                        : _handleAddComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Post',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'chat_bubble_outline',
            color: colorScheme.onSurface.withValues(alpha: 0.3),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No comments yet',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Be the first to ask a question or leave a comment',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(BuildContext context, Map<String, dynamic> comment) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment header
          Row(
            children: [
              CircleAvatar(
                radius: 4.w,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                child: comment['avatar'] != null
                    ? CustomImageWidget(
                        imageUrl: comment['avatar'] as String,
                        width: 8.w,
                        height: 8.w,
                        fit: BoxFit.cover,
                      )
                    : CustomIconWidget(
                        iconName: 'person',
                        color: colorScheme.primary,
                        size: 4.w,
                      ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['name'] as String? ?? 'Anonymous',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatCommentTime(comment['timestamp'] as String? ?? ''),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Comment content
          Text(
            comment['content'] as String? ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),

          SizedBox(height: 2.h),

          // Comment actions
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement like functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Like feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'thumb_up_outlined',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 16,
                ),
                label: Text(
                  '${comment['likes'] ?? 0}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement reply functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reply feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'reply',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 16,
                ),
                label: Text(
                  'Reply',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAddComment() {
    final commentText = _commentController.text.trim();
    if (commentText.isNotEmpty && widget.onAddComment != null) {
      widget.onAddComment!(commentText);
      _commentController.clear();
      _commentFocusNode.unfocus();
    }
  }

  String _formatCommentTime(String timestamp) {
    if (timestamp.isEmpty) return '';

    try {
      final time = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(time);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inMinutes}m ago';
      }
    } catch (e) {
      return timestamp;
    }
  }
}
