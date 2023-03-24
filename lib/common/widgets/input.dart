import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../configuration/app_resources.dart';

class Input extends ConsumerStatefulWidget {
  const Input({
    Key? key,
    required this.label,
    this.obscureInput = false,
    this.trailing,
    this.keyboardType,
  }) : super(key: key);

  final String label;
  final bool obscureInput;
  final TextInputType? keyboardType;
  final Widget? trailing;

  @override
  ConsumerState<Input> createState() => _InputState();
}

class _InputState extends ConsumerState<Input> {
  final _focused = StateProvider((ref) => false);
  final _inputFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FocusScope(
      child: Focus(
        onFocusChange: (value) {
          ref.read(_focused.notifier).state = value;
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_inputFocus),
          child: Container(
            padding: const EdgeInsets.all(AppPadding.medium),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary,
              border: Border.all(
                color: ref.watch(_focused)
                    ? theme.textTheme.bodyMedium?.color ?? Colors.black
                    : const Color(0xFF96A3B1),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: theme.textTheme.labelSmall,
                      ),
                      TextField(
                        focusNode: _inputFocus,
                        keyboardType: widget.keyboardType,
                        obscureText: widget.obscureInput,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputFocus.dispose();
    super.dispose();
  }
}

class PasswordInput extends ConsumerStatefulWidget {
  const PasswordInput({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  ConsumerState<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends ConsumerState<PasswordInput> {
  final _isVisible = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context) {
    final isVisible = ref.watch(_isVisible);

    return Input(
      label: widget.label,
      obscureInput: !isVisible,
      keyboardType: isVisible ? null : TextInputType.visiblePassword,
      trailing: InkWell(
        onTap: () => ref.read(_isVisible.notifier).state = !isVisible,
        child: Icon(
          isVisible ? Icons.visibility_off : Icons.visibility,
        ),
      ),
    );
  }
}
