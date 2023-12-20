# Questions and Answers
Ruby on Rails application for asking questions and getting answers 

## Table of Contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Features](#features)
* [Setup](#setup)
* [Usage](#usage)
* [Project status](#project-status)

## General info
It is a Ruby on Rails application which helps users to find out answers to their questions.

## Technologies
Project is created with:
* Ruby version: 3
* Rails version: 7
* Bootstrap version: 5
* PostgreSQL

## Features
* Authentication with Devise gem
* Authorization with CanCanCan gem
* Application is created in Test Driven Development methodology
* Users can log in via VK and GitHub
* Ful-text search with Sphinx

## Setup
To run this project locally, you have to install Ruby and necessary gems on your computer.
Follow these steps:
  1. Clone the project repository: git clone `https://github.com/mvpurin/qna.git`
  2. Run bundle install to get necessary gems
  3. Run rails `db:drop`
  4. Run rails `db:create`
  5. Run rails `db:migrate`

## Usage
Users can add new questions and answers. It is possible to vote for useful questions and answers.

## Project status
Project is complete for now.
