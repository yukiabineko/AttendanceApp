#既存のプロジェクトのrubyのバージョンを指定
FROM ruby:2.5.7

#パッケージの取得
RUN apt-get update && apt-get install -y --no-install-recommends  \
    nodejs  \
    vim    \
    mariadb-client  \
    build-essential  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*    
WORKDIR /myproject

COPY Gemfile /myproject/Gemfile
COPY Gemfile.lock /myproject/Gemfile.lock

RUN gem install bundler
RUN bundle install

#既存railsプロジェクトをコンテナ内にコピー
COPY . /myproject