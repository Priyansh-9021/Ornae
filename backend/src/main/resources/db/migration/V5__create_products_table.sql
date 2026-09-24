CREATE TABLE products (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(255) NOT NULL,
    description     TEXT,
    category_id     UUID NOT NULL REFERENCES categories (id),
    metal_type      VARCHAR(50) NOT NULL,
    price           NUMERIC(12, 2) NOT NULL,
    currency        VARCHAR(3) NOT NULL DEFAULT 'INR',
    stock           INTEGER NOT NULL DEFAULT 0,
    glb_model_url   VARCHAR(1024),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_products_category_id ON products (category_id);
CREATE INDEX idx_products_metal_type ON products (metal_type);
CREATE INDEX idx_products_price ON products (price);
