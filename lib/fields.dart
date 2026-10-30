// Single source of truth for the tracker structure.
// The Today screen, History, and Markdown export all read from these definitions.

enum FieldType { text, multiline, number, slider, check, choice }

class FieldDef {
  const FieldDef(this.key, this.label, this.type, {this.options});

  final String key;
  final String label;
  final FieldType type;
  final List<String>? options;
}

class SectionDef {
  const SectionDef(this.id, this.title, this.quick, this.fields);

  final String id;
  final String title;

  /// Quick sections open by default on the Today screen (the 5-minute check).
  final bool quick;
  final List<FieldDef> fields;
}

const _scale3 = ['None', 'Mild', 'Strong'];

const sections = [
  SectionDef('daily', 'Daily Log', true, [
    FieldDef('type', 'Type of day', FieldType.choice, options: [
      'Workday', 'Weekend', 'Holiday', 'Festival', 'Travel', 'Sick', 'Rest', 'Busy', 'Slow',
    ]),
    FieldDef('rating', 'Overall day rating', FieldType.slider),
    FieldDef('p1', 'Top priority 1', FieldType.text),
    FieldDef('p2', 'Top priority 2', FieldType.text),
    FieldDef('p3', 'Top priority 3', FieldType.text),
    FieldDef('win', 'Biggest win', FieldType.text),
    FieldDef('drain', 'Biggest drain', FieldType.text),
    FieldDef('did', 'What I did today', FieldType.multiline),
    FieldDef('lesson', 'One lesson', FieldType.text),
    FieldDef('tomorrow', 'First task for tomorrow', FieldType.text),
  ]),
  SectionDef('sleep', 'Sleep', true, [
    FieldDef('target', 'Target bedtime', FieldType.text),
    FieldDef('bed', 'Went to bed at', FieldType.text),
    FieldDef('on_target', 'Slept by target time', FieldType.check),
    FieldDef('hours', 'Total sleep (hours)', FieldType.number),
    FieldDef('fall_asleep', 'Time to fall asleep (minutes)', FieldType.number),
    FieldDef('wake', 'Woke up at', FieldType.text),
    FieldDef('wakeups', 'Wake-ups and reason', FieldType.text),
    FieldDef('before_bed', 'Activity before sleep', FieldType.text),
    FieldDef('energy_wake', 'Energy on waking', FieldType.slider),
    FieldDef('quality', 'Sleep quality', FieldType.slider),
  ]),
  SectionDef('mind', 'Mind & Mood', true, [
    FieldDef('mood', 'Mood', FieldType.slider),
    FieldDef('energy', 'Energy', FieldType.slider),
    FieldDef('stress', 'Stress', FieldType.slider),
    FieldDef('happiness', 'Happiness', FieldType.slider),
    FieldDef('smile', 'Something that made me smile', FieldType.text),
    FieldDef('journal', 'Short journal', FieldType.multiline),
  ]),
  SectionDef('habits', 'Habits & Routines', true, [
    FieldDef('prayer', 'Prayer', FieldType.check),
    FieldDef('reading', 'Reading', FieldType.check),
    FieldDef('walk', 'Walking or exercise', FieldType.check),
    FieldDef('skill', 'Skill practice', FieldType.check),
    FieldDef('gratitude', 'Journal or gratitude', FieldType.check),
    FieldDef('screen', 'Screen time under limit', FieldType.check),
    FieldDef('building', 'Habit I am building this week', FieldType.text),
    FieldDef('breaking', 'Habit I am breaking this week', FieldType.text),
  ]),
  SectionDef('health', 'Meals, Gut & Health', false, [
    FieldDef('meals', 'Meals (breakfast, lunch, dinner, snacks)', FieldType.multiline),
    FieldDef('healthy_meals', 'Healthy meals (out of 3)', FieldType.number),
    FieldDef('water', 'Water (glasses)', FieldType.number),
    FieldDef('fibre', 'Fibre, fruit and vegetables', FieldType.text),
    FieldDef('hunger', 'Hunger and fullness', FieldType.choice,
        options: ['Normal', 'Low', 'High', 'Skipped meals']),
    FieldDef('activity', 'Activity and exercise', FieldType.text),
    FieldDef('bowel', 'Bowel movements (count)', FieldType.number),
    FieldDef('stool', 'Stool consistency', FieldType.choice,
        options: ['Normal', 'Hard', 'Loose', 'Mixed']),
    FieldDef('straining', 'Straining or incomplete emptying', FieldType.check),
    FieldDef('bloating', 'Bloating', FieldType.choice, options: _scale3),
    FieldDef('gas', 'Gas', FieldType.choice, options: _scale3),
    FieldDef('acidity', 'Acidity or heartburn', FieldType.choice, options: _scale3),
    FieldDef('stomach_pain', 'Stomach pain or cramps (where, how strong)', FieldType.text),
    FieldDef('nausea', 'Nausea', FieldType.check),
    FieldDef('after_meal', 'Discomfort after meals (which meal)', FieldType.text),
    FieldDef('triggers', 'Foods that seemed to cause a problem', FieldType.text),
    FieldDef('probiotic', 'Probiotic or digestive supplement', FieldType.text),
    FieldDef('symptoms', 'Other symptoms (what, where, severity 1-10)', FieldType.text),
    FieldDef('medicines', 'Medicines taken (name, dose, time)', FieldType.text),
  ]),
  SectionDef('work', 'Work & Learning', false, [
    FieldDef('tasks_planned', 'Tasks planned', FieldType.number),
    FieldDef('tasks_done', 'Tasks completed', FieldType.number),
    FieldDef('deep_hours', 'Deep work hours', FieldType.number),
    FieldDef('skill_hours', 'Study or skill hours', FieldType.number),
    FieldDef('skill_name', 'Skill I worked on', FieldType.text),
    FieldDef('output', 'What I produced', FieldType.text),
    FieldDef('career', 'Career progress (applications, replies, networking, courses)', FieldType.text),
    FieldDef('goal', 'Goal I moved forward', FieldType.text),
    FieldDef('goal_progress', 'How much I moved it', FieldType.slider),
    FieldDef('blockers', 'Blockers', FieldType.text),
    FieldDef('pending', 'Pending for tomorrow', FieldType.text),
  ]),
  SectionDef('money', 'Money', false, [
    FieldDef('income', 'Income (source, amount)', FieldType.text),
    FieldDef('spent', 'Total spent', FieldType.number),
    FieldDef('expenses', 'Expenses (item, category, amount)', FieldType.multiline),
    FieldDef('no_spend', 'No-spend day', FieldType.check),
    FieldDef('saved', 'Saved or invested', FieldType.number),
    FieldDef('bills', 'Bills due in the next 7 days (bill, date, amount, paid)', FieldType.multiline),
  ]),
  SectionDef('social', 'Social', false, [
    FieldDef('in_person', 'In-person interaction today (who, what happened)', FieldType.text),
    FieldDef('non_person', 'Non-person interaction today (call, message, video; who, what)', FieldType.text),
    FieldDef('social_energy', 'Social energy', FieldType.choice,
        options: ['Charged', 'Neutral', 'Drained']),
  ]),
  SectionDef('activities', 'Activities & Experiences', false, [
    FieldDef('major', 'Major activities (planned or unplanned, time, outcome)', FieldType.multiline),
    FieldDef('unexpected', 'Unexpected events (cause, time lost or gained, response)', FieldType.multiline),
    FieldDef('gaps', 'Gap-filling activities (between tasks)', FieldType.multiline),
    FieldDef('gap_common', 'Most common gap activity today', FieldType.text),
    FieldDef('training', 'Training and practice (skill, drill, reps, difficulty)', FieldType.multiline),
    FieldDef('next_practice', 'Next practice step', FieldType.text),
    FieldDef('new_things', 'New things I tried', FieldType.text),
    FieldDef('memories', 'Things I want to remember', FieldType.multiline),
  ]),
];
