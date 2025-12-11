FROM ruby:3.2-slim

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY Gemfile* ./
RUN bundle install

# Copy application files
COPY . .

# Expose port
EXPOSE 4567

# Run the application
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "4567"]
