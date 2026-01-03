import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';

class AddCoursePage extends StatelessWidget {
  const AddCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCourseCubit(
        user: context.read<AppCubit>().state.user!,
        addCourseUseCase: getIt<AddCourseUseCase>(),
      ),
      child: AddCourseView(),
    );
  }
}

class AddCourseView extends StatelessWidget {
  const AddCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddCourseCubit>();
    final isLoading = context.select(
      (AddCourseCubit cubit) => cubit.state.status.isLoading,
    );
    final canSubmit = context.select(
      (AddCourseCubit cubit) => cubit.state.canSubmit,
    );

    return BlocListener<AddCourseCubit, AddCourseState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.status.isLoading) {
          showLoadingOverlay(context);
        } else {
          hideLoadingOverlay();
        }

        if (state.status.isError && state.errorMessage != null) {
          openSnackbar(SnackbarMessage.error(title: state.errorMessage!));
        }

        if (state.status.isSuccess) {
          openSnackbar(
            const SnackbarMessage.success(title: 'Course added successfully.'),
          );
        }
      },
      child: AppScaffold(
        appBar: AppBar(title: const Text('Add Course'), centerTitle: true),
        body: AppConstrainedScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.lg,
            children: [
              AppTextField.underlineBorder(
                enabled: !isLoading,
                hintText: 'Course code',
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.tag_outlined),
                onChanged: cubit.onCodeChanged,
              ),
              AppTextField.underlineBorder(
                enabled: !isLoading,
                hintText: 'Course name',
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.menu_book_outlined),
                onChanged: cubit.onNameChanged,
              ),
              AppTextField.underlineBorder(
                enabled: !isLoading,
                hintText: 'Level',
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.stairs_outlined),
                onChanged: cubit.onLevelChanged,
              ),
              AppButton(
                text: isLoading ? 'Adding...' : 'Add Course',
                width: double.infinity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                    horizontal: AppSpacing.lg,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                ),
                onPressed: isLoading || !canSubmit
                    ? null
                    : () => cubit.submit(
                        onSuccess: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
