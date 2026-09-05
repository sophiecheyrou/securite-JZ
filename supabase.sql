-- ALERTE JZ — SUPABASE V10
-- À exécuter UNE FOIS dans Supabase > SQL Editor > New query > Run

create table if not exists public.rooms (
  room_number text primary key,
  floor integer check (floor between 1 and 5),
  side text check (side in ('PAIR','IMPAIR')),
  courtyard text,
  active boolean not null default true
);

create table if not exists public.exercises (
  id bigint generated always as identity primary key,
  started_at timestamptz not null default now(),
  ended_at timestamptz,
  is_active boolean not null default true
);

create table if not exists public.room_states (
  exercise_id bigint not null references public.exercises(id) on delete cascade,
  room_number text not null references public.rooms(room_number),
  status text not null check (status in ('PRESENT','SORTI','NON_LOCALISE')),
  station text,
  device_id text,
  updated_at timestamptz not null default now(),
  primary key (exercise_id, room_number)
);

create table if not exists public.room_status_events (
  id bigint generated always as identity primary key,
  exercise_id bigint not null references public.exercises(id) on delete cascade,
  room_number text not null references public.rooms(room_number),
  status text not null check (status in ('PRESENT','SORTI','NON_LOCALISE')),
  previous_status text check (previous_status in ('PRESENT','SORTI','NON_LOCALISE')),
  station text,
  device_id text,
  created_at timestamptz not null default now()
);

alter table public.room_status_events add column if not exists previous_status text;
alter table public.room_status_events add column if not exists device_id text;

create table if not exists public.exercise_archives (
  id bigint generated always as identity primary key,
  exercise_id bigint references public.exercises(id) on delete set null,
  snapshot jsonb not null,
  created_at timestamptz not null default now()
);

-- Une seule session d'exercice active à la fois.
with ranked as (
  select id, row_number() over (order by started_at desc, id desc) as rn
  from public.exercises where is_active = true
)
update public.exercises e
set is_active = false, ended_at = coalesce(ended_at, now())
from ranked r
where e.id = r.id and r.rn > 1;

create unique index if not exists one_active_exercise
on public.exercises ((is_active)) where is_active = true;

-- Import de la liste de chambres de la V9.
insert into public.rooms (room_number, floor, side, courtyard, active) values
  ('125', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('126', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('127', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('128', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('129', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('130', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('131', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('132', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('133', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('134', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('135', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('136', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('137', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('138', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('139', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('140', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('141', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('142', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('143', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('144', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('145', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('146', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('147', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('148', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('149', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('150', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('151', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('152', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('153', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('154', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('155', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('156', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('157', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('158', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('159', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('160', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('161', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('162', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('163', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('164', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('165', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('166', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('167', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('168', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('169', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('170', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('171', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('172', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('173', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('174', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('175', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('176', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('201', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('202', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('203', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('204', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('205', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('206', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('207', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('208', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('209', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('210', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('211', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('212', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('213', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('214', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('215', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('216', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('217', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('218', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('219', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('220', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('221', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('222', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('223', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('224', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('225', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('226', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('227', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('228', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('229', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('230', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('231', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('232', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('233', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('234', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('235', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('236', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('237', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('238', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('239', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('240', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('241', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('242', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('243', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('244', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('245', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('246', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('247', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('248', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('249', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('250', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('251', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('252', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('253', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('254', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('255', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('256', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('257', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('258', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('259', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('260', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('261', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('262', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('263', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('264', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('265', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('266', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('267', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('268', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('269', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('270', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('271', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('272', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('273', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('274', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('275', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('276', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('277', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('278', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('279', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('280', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('281', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('282', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('283', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('284', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('287', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('291', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('302', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('304', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('305', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('306', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('307', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('308', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('309', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('310', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('311', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('312', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('313', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('314', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('315', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('316', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('317', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('318', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('319', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('320', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('321', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('322', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('323', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('324', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('325', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('326', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('327', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('328', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('329', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('330', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('331', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('332', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('333', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('334', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('335', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('336', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('337', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('338', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('339', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('340', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('341', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('342', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('343', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('344', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('345', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('346', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('347', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('348', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('349', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('350', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('351', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('352', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('353', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('354', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('355', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('356', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('357', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('358', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('359', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('360', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('361', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('362', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('363', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('364', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('365', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('366', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('367', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('368', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('369', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('370', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('372', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('373', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('374', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('375', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('376', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('377', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('378', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('379', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('380', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('381', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('382', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('383', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('384', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('385', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('387', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('388', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('391', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('403', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('404', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('405', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('406', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('407', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('408', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('409', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('410', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('411', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('412', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('413', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('414', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('415', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('416', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('417', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('418', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('419', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('420', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('421', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('422', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('423', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('424', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('425', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('426', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('427', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('428', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('429', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('430', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('431', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('432', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('433', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('434', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('435', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('436', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('437', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('438', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('439', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('440', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('441', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('442', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('443', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('444', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('445', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('446', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('447', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('448', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('449', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('450', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('451', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('452', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('453', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('454', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('455', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('456', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('457', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('458', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('459', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('460', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('461', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('462', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('463', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('464', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('465', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('466', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('467', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('468', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('469', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('470', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('471', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('472', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('473', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('474', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('475', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('476', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('477', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('478', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('479', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('480', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('481', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('482', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('483', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('484', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('485', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('486', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('487', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('488', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('491', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('503', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('504', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('505', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('506', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('507', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('508', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('509', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('510', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('511', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('512', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('513', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('514', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('515', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('516', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('517', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('518', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('519', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('520', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('521', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('522', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('523', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('524', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('525', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('526', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('527', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('528', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('529', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('530', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('531', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('532', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('533', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('534', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('535', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('536', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('537', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('538', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('539', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('540', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('541', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('542', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('543', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('544', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('545', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('546', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('547', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('548', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('549', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('550', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('551', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('552', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('553', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('554', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('555', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('556', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('557', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('558', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('559', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('560', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('561', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('562', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('563', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('564', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('565', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('566', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('567', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('568', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('569', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('570', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('571', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('572', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('573', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('574', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('575', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('576', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('577', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('578', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('579', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('580', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('581', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('582', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('583', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('584', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('585', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('586', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('587', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('588', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('590', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('C.20', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('C.21', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('C.22', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('F.21', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F.20', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('F.22', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('F.23', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F.24', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('F.25', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F.30', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('F.31', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F.32', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('F.33', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F.34', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('F.35', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F.40', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('F.41', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F.42', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('F.43', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F.45', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F.51', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F.52', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('F.53', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F.55', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('F54', 5, 'PAIR', 'COUR MONTMORENCY', true),
  ('R15', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('R20B', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('R10A', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('R10B', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('R11A', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('R11B', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('R12A', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('R12B', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('R20A', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('R21B', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('R22A', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('R22.B', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('R30.A', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('RC1', null, null, null, true),
  ('RC3B', null, null, null, true),
  ('RC3C', null, null, null, true),
  ('RC4A', null, null, null, true),
  ('RC4B', null, null, null, true),
  ('RC2A', null, null, null, true),
  ('RC2B', null, null, null, true),
  ('RC3A', null, null, null, true),
  ('S.10', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('S.21', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('S.22', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('S.41', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('S.43', 4, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('S.53', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('S.11', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('S.12', 1, 'PAIR', 'COUR MONTMORENCY', true),
  ('S.13', 1, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('S.20', 2, 'PAIR', 'COUR MONTMORENCY', true),
  ('S.23', 2, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('S.30', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('S.31', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('S.32', 3, 'PAIR', 'COUR MONTMORENCY', true),
  ('S.33', 3, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('S.40', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('S.42', 4, 'PAIR', 'COUR MONTMORENCY', true),
  ('S.51', 5, 'IMPAIR', 'COUR D''HONNEUR', true),
  ('303', 3, 'IMPAIR', null, false)
on conflict (room_number) do update set
  floor = excluded.floor,
  side = excluded.side,
  courtyard = excluded.courtyard,
  active = excluded.active;

-- Fonction : récupère ou crée l'exercice actif, sans risque de doublon.
create or replace function public.ensure_active_exercise()
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare v_id bigint;
begin
  perform pg_advisory_xact_lock(74102501);
  select id into v_id from public.exercises where is_active = true order by started_at desc limit 1;
  if v_id is null then
    insert into public.exercises(is_active) values(true) returning id into v_id;
  end if;
  return v_id;
end;
$$;

-- Fonction : démarre un nouvel exercice pour TOUS les appareils.
create or replace function public.start_new_exercise()
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare v_id bigint;
begin
  perform pg_advisory_xact_lock(74102501);
  update public.exercises
     set is_active = false, ended_at = coalesce(ended_at, now())
   where is_active = true;
  insert into public.exercises(is_active) values(true) returning id into v_id;
  return v_id;
end;
$$;

-- Fonction atomique : met à jour le statut courant ET conserve l'historique du clic.
create or replace function public.record_room_status(
  p_exercise_id bigint,
  p_room_number text,
  p_status text,
  p_station text default null,
  p_device_id text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare v_previous text;
begin
  if p_status not in ('PRESENT','SORTI','NON_LOCALISE') then
    raise exception 'Statut invalide';
  end if;
  if not exists (select 1 from public.exercises where id=p_exercise_id and is_active=true) then
    raise exception 'Cet exercice n est plus actif';
  end if;
  if not exists (select 1 from public.rooms where room_number=p_room_number and active=true) then
    raise exception 'Chambre inconnue';
  end if;

  select status into v_previous
  from public.room_states
  where exercise_id=p_exercise_id and room_number=p_room_number;
  v_previous := coalesce(v_previous, 'NON_LOCALISE');

  insert into public.room_states(exercise_id,room_number,status,station,device_id,updated_at)
  values(p_exercise_id,p_room_number,p_status,p_station,p_device_id,now())
  on conflict (exercise_id,room_number) do update set
    status=excluded.status, station=excluded.station, device_id=excluded.device_id, updated_at=excluded.updated_at;

  insert into public.room_status_events(exercise_id,room_number,status,previous_status,station,device_id)
  values(p_exercise_id,p_room_number,p_status,v_previous,p_station,p_device_id);
end;
$$;

-- Sécurité : la clé publique lit les données nécessaires, mais les écritures opérationnelles passent par les fonctions ci-dessus.
alter table public.rooms enable row level security;
alter table public.exercises enable row level security;
alter table public.room_states enable row level security;
alter table public.room_status_events enable row level security;
alter table public.exercise_archives enable row level security;

revoke all on public.rooms, public.exercises, public.room_states, public.room_status_events, public.exercise_archives from anon;
grant usage on schema public to anon;
grant select on public.rooms, public.exercises, public.room_states, public.room_status_events to anon;
grant select, insert, delete on public.exercise_archives to anon;
grant usage, select on sequence public.exercise_archives_id_seq to anon;

drop policy if exists "read rooms" on public.rooms;
drop policy if exists "read exercises" on public.exercises;
drop policy if exists "read room states" on public.room_states;
drop policy if exists "read events" on public.room_status_events;
drop policy if exists "read archives" on public.exercise_archives;
drop policy if exists "insert archives" on public.exercise_archives;
drop policy if exists "delete archives" on public.exercise_archives;

create policy "read rooms" on public.rooms for select to anon using (true);
create policy "read exercises" on public.exercises for select to anon using (true);
create policy "read room states" on public.room_states for select to anon using (true);
create policy "read events" on public.room_status_events for select to anon using (true);
create policy "read archives" on public.exercise_archives for select to anon using (true);
create policy "insert archives" on public.exercise_archives for insert to anon with check (true);
create policy "delete archives" on public.exercise_archives for delete to anon using (true);

revoke all on function public.ensure_active_exercise() from public;
revoke all on function public.start_new_exercise() from public;
revoke all on function public.record_room_status(bigint,text,text,text,text) from public;
grant execute on function public.ensure_active_exercise() to anon;
grant execute on function public.start_new_exercise() to anon;
grant execute on function public.record_room_status(bigint,text,text,text,text) to anon;

-- Realtime : les changements de chambres et de session sont diffusés à tous les téléphones.
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='room_states') then
    alter publication supabase_realtime add table public.room_states;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='exercises') then
    alter publication supabase_realtime add table public.exercises;
  end if;
end $$;

-- Crée la première session si nécessaire.
select public.ensure_active_exercise();
