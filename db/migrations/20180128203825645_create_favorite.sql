-- +micrate Up
CREATE TABLE favorites (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT,
  article_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX favorite_user_id_idx ON favorites (user_id);
CREATE INDEX favorite_article_id_idx ON favorites (article_id);

-- +micrate Down
DROP TABLE IF EXISTS favorites;
