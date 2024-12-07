# Use Node.js base image
FROM node:14

# Create app directory
WORKDIR /usr/src/app

# Copy app files
COPY package*.json ./
COPY server.js ./

# Install dependencies
RUN npm install

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
