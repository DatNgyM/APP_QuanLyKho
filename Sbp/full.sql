-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.Role (
  id integer NOT NULL DEFAULT nextval('"Role_id_seq"'::regclass),
  name text NOT NULL,
  description text,
  CONSTRAINT Role_pkey PRIMARY KEY (id)
);
CREATE TABLE public._prisma_migrations (
  id character varying NOT NULL,
  checksum character varying NOT NULL,
  finished_at timestamp with time zone,
  migration_name character varying NOT NULL,
  logs text,
  rolled_back_at timestamp with time zone,
  started_at timestamp with time zone NOT NULL DEFAULT now(),
  applied_steps_count integer NOT NULL DEFAULT 0,
  CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id)
);
CREATE TABLE public.brands (
  id integer NOT NULL DEFAULT nextval('brands_id_seq'::regclass),
  name text NOT NULL,
  slug text NOT NULL,
  logo text,
  description text,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT brands_pkey PRIMARY KEY (id)
);
CREATE TABLE public.categories (
  id integer NOT NULL DEFAULT nextval('categories_id_seq'::regclass),
  name text NOT NULL,
  slug text,
  description text,
  CONSTRAINT categories_pkey PRIMARY KEY (id)
);
CREATE TABLE public.coupons (
  id integer NOT NULL DEFAULT nextval('coupons_id_seq'::regclass),
  code character varying NOT NULL UNIQUE,
  description text,
  discount_type character varying NOT NULL,
  discount_value numeric NOT NULL,
  min_order_amount numeric,
  max_discount numeric,
  usage_limit integer,
  used_count integer NOT NULL DEFAULT 0,
  start_date timestamp without time zone NOT NULL,
  end_date timestamp without time zone NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT coupons_pkey PRIMARY KEY (id)
);
CREATE TABLE public.newsletter (
  id integer NOT NULL DEFAULT nextval('newsletter_id_seq'::regclass),
  email text NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT newsletter_pkey PRIMARY KEY (id)
);
CREATE TABLE public.order_items (
  id integer NOT NULL DEFAULT nextval('order_items_id_seq'::regclass),
  order_id integer NOT NULL,
  product_id integer NOT NULL,
  quantity integer NOT NULL,
  unit_price numeric NOT NULL,
  CONSTRAINT order_items_pkey PRIMARY KEY (id),
  CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id),
  CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);
CREATE TABLE public.orders (
  id integer NOT NULL DEFAULT nextval('orders_id_seq'::regclass),
  user_id text,
  order_date timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status text NOT NULL DEFAULT 'Processing'::text,
  total_amount numeric NOT NULL DEFAULT 0,
  staff_id character varying,
  subtotal numeric NOT NULL DEFAULT 0,
  discount_amount numeric NOT NULL DEFAULT 0,
  coupon_ids ARRAY DEFAULT ARRAY[]::integer[],
  payment_method character varying DEFAULT 'COD'::character varying,
  CONSTRAINT orders_pkey PRIMARY KEY (id),
  CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT orders_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.users(id)
);
CREATE TABLE public.products (
  id integer NOT NULL DEFAULT nextval('products_id_seq'::regclass),
  category_id integer,
  brand_id integer,
  name text NOT NULL,
  sku text NOT NULL,
  price numeric NOT NULL,
  quantity integer NOT NULL DEFAULT 0,
  description text,
  image_url text,
  images ARRAY DEFAULT ARRAY[]::text[],
  rating double precision DEFAULT 0,
  reviews integer DEFAULT 0,
  discount integer DEFAULT 0,
  badges ARRAY DEFAULT ARRAY[]::text[],
  features ARRAY DEFAULT ARRAY[]::text[],
  origin text,
  release_date text,
  warranty text,
  dimensions text,
  weight text,
  waterproof text,
  material text,
  cpu text,
  cpu_cores text,
  gpu text,
  ram text,
  rom text,
  screen_size text,
  screen_tech text,
  resolution text,
  screen_colors text,
  refresh_rate text,
  brightness text,
  rear_camera text,
  front_camera text,
  camera_features ARRAY DEFAULT ARRAY[]::text[],
  battery_type text,
  battery_capacity text,
  charging text,
  os text,
  os_version text,
  sim text,
  network text,
  wifi text,
  bluetooth text,
  port text,
  gps text,
  nfc text,
  security ARRAY DEFAULT ARRAY[]::text[],
  other_features ARRAY DEFAULT ARRAY[]::text[],
  accessories text,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  flash_sale boolean DEFAULT false,
  flash_sale_order integer,
  flash_sale_end_time timestamp without time zone,
  specifications jsonb,
  CONSTRAINT products_pkey PRIMARY KEY (id),
  CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id),
  CONSTRAINT products_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id)
);
CREATE TABLE public.reviews (
  id integer NOT NULL DEFAULT nextval('reviews_id_seq'::regclass),
  product_id integer NOT NULL,
  user_id character varying NOT NULL,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment text NOT NULL,
  images ARRAY DEFAULT '{}'::text[],
  is_verified boolean DEFAULT false,
  staff_reply text,
  replied_at timestamp without time zone,
  replied_by character varying DEFAULT NULL::character varying,
  is_visible boolean DEFAULT true,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT reviews_pkey PRIMARY KEY (id),
  CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id),
  CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.smart_alerts (
  id integer NOT NULL DEFAULT nextval('smart_alerts_id_seq'::regclass),
  product_id integer,
  alert_type text,
  message text,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_read boolean NOT NULL DEFAULT false,
  CONSTRAINT smart_alerts_pkey PRIMARY KEY (id),
  CONSTRAINT smart_alerts_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);
CREATE TABLE public.staff_performance (
  id integer NOT NULL DEFAULT nextval('staff_performance_id_seq'::regclass),
  staff_id character varying NOT NULL UNIQUE,
  total_orders integer NOT NULL DEFAULT 0,
  completed_orders integer NOT NULL DEFAULT 0,
  total_revenue numeric NOT NULL DEFAULT 0,
  commission numeric NOT NULL DEFAULT 0,
  last_updated timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT staff_performance_pkey PRIMARY KEY (id),
  CONSTRAINT staff_performance_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.users(id)
);
CREATE TABLE public.user_logs (
  id integer NOT NULL DEFAULT nextval('user_logs_id_seq'::regclass),
  user_id text,
  action text,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT user_logs_pkey PRIMARY KEY (id),
  CONSTRAINT user_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.users (
  id text NOT NULL,
  full_name text NOT NULL,
  email text NOT NULL,
  password_hash text,
  role_id integer,
  is_active boolean NOT NULL DEFAULT true,
  avatar_url text,
  phone text,
  address text,
  city text,
  district text,
  ward text,
  payment_method text,
  bank_name text,
  bank_account text,
  created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.Role(id)
);