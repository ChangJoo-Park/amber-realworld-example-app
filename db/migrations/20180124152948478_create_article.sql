-- +micrate Up
CREATE TABLE articles (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR,
  body TEXT,
  user_id BIGINT,
  tag_id BIGINT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX article_user_id_idx ON articles (user_id);
CREATE INDEX article_tag_id_idx ON articles (tag_id);

-- +micrate Down
DROP TABLE IF EXISTS articles;
