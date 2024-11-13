import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_shop/routes/app_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_shop/shared/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final themeMode = ref.watch(appThemeProvider);
    return ScreenUtilInit(
      designSize: ScreenUtil.defaultSize,
      minTextAdapt: true,
      ensureScreenSize: true,
      fontSizeResolver: FontSizeResolvers.height,
      child: MaterialApp(
        title: 'Online Shop',
        // themeMode: themeMode,
        builder: (context, widget) {
          return ScrollConfiguration(
            behavior: const _GlobalScrollBehavior(),
            child: widget!,
          );
        },
        theme: AppTheme.defaultTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.onGenerateRouted,
      ),
    );
  }
}

class _GlobalScrollBehavior extends ScrollBehavior {
  const _GlobalScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(_) => const BouncingScrollPhysics();
}
