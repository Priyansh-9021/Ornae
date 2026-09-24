CREATE TABLE categories (
    id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name    VARCHAR(100) NOT NULL,
    slug    VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO categories (name, slug) VALUES
    ('Rings', 'rings'),
    ('Earrings', 'earrings'),
    ('Necklaces', 'necklaces'),
    ('Bracelets', 'bracelets');
