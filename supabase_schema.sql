-- ============================================================
-- SCHEMA — Dashboard Móveis & Colchões
-- Execute este arquivo no SQL Editor do Supabase
-- ============================================================

-- Clientes (compradores parcelados no pix)
create table if not exists clientes (
  id         uuid primary key default gen_random_uuid(),
  nome       text not null,
  tel        text,
  prod       text,
  total      numeric,
  nparc      int,
  parc_val   numeric,
  indicado   text,
  created_at timestamptz default now()
);

-- Parcelas de cada cliente
create table if not exists parcelas (
  id         uuid primary key default gen_random_uuid(),
  cliente_id uuid references clientes(id) on delete cascade,
  num        int,
  venc       date,
  valor      numeric,
  paga       boolean default false
);

-- Boletos de fornecedores
create table if not exists boletos (
  id         uuid primary key default gen_random_uuid(),
  fornecedor text,
  descricao  text,
  valor      numeric,
  venc       date,
  pago       boolean default false,
  created_at timestamptz default now()
);

-- Vendas pelas plataformas online (ML, OLX, Shopee)
create table if not exists vendas_online (
  id         uuid primary key default gen_random_uuid(),
  plat       text,   -- 'ML', 'OLX', 'Shopee'
  prod       text,
  valor      numeric,
  data       date,
  status     text default 'aguardando repasse',  -- ou 'repassado'
  created_at timestamptz default now()
);

-- Estoque de produtos
create table if not exists estoque (
  id      uuid primary key default gen_random_uuid(),
  nome    text unique,
  estoque int default 0
);

-- ============================================================
-- Row Level Security (permite acesso com a chave anon)
-- ============================================================
alter table clientes     enable row level security;
alter table parcelas     enable row level security;
alter table boletos      enable row level security;
alter table vendas_online enable row level security;
alter table estoque      enable row level security;

create policy "acesso_total" on clientes      for all using (true) with check (true);
create policy "acesso_total" on parcelas      for all using (true) with check (true);
create policy "acesso_total" on boletos       for all using (true) with check (true);
create policy "acesso_total" on vendas_online for all using (true) with check (true);
create policy "acesso_total" on estoque       for all using (true) with check (true);

-- ============================================================
-- Estoque inicial com os 8 produtos
-- ============================================================
insert into estoque (nome, estoque) values
  ('Beliche solteiro MDF',  4),
  ('Beliche casal MDF',     3),
  ('Colchão solteiro',      8),
  ('Colchão casal',         6),
  ('Cama box casal',        5),
  ('Guarda-roupa 2 portas', 3),
  ('Guarda-roupa 4 portas', 2),
  ('Sofá 3 lugares',        4)
on conflict (nome) do nothing;
