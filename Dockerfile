# Stage 1: Build the React app
FROM node:18 AS builder

# Set working directory
WORKDIR /app
# Copy project files

# Install dependencies
COPY . .
RUN yarn install --frozen-lockfile
RUN yarn build

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine

# Copy built files to Nginx HTML folder
COPY --from=builder /app/build /usr/share/nginx/html

# Remove default Nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Add custom Nginx config
COPY nginx.conf /etc/nginx/conf.d

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
