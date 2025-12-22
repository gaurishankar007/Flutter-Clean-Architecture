part of 'dashboard_cubit.dart';

class DashboardState extends BaseState {
  const DashboardState({required this.activeIndex});

  factory DashboardState.initial() => const DashboardState(activeIndex: 0);
  final int activeIndex;

  DashboardState copyWith({int? activeIndex}) =>
      DashboardState(activeIndex: activeIndex ?? this.activeIndex);

  @override
  List<Object> get props => [activeIndex];
}
