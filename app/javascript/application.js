// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "./jquery_ui"
import Rails from '@rails/ujs';

const openaiAccessToken = document.body.getAttribute('data-openai-access-token');

// Function to fetch trivia categories from GPT API and display them as buttons
function displayCategories() {
  // Fetch categories from GPT API
  if (document.getElementById('category-buttons')) {
    // Show spinner while categories are being fetched
    const spinner = document.getElementById('spinner');
    spinner.style.display = 'block';

    // Fetch categories from GPT API
    // WHILE CHAT GPT PROVIDED THIS ENTIRE fuction CODE
    // IT WAS USING A DIFERENT ENGINE WHICH WAS RETURNING CODE, WHICH WAS THEN NOT PARSED CORRECTLY
    fetch('https://api.openai.com/v1/engines/text-davinci-003/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization':  `Bearer ${openaiAccessToken}`,
      },
      body: JSON.stringify({
        prompt: 'Give me 5 random trivia categories, make 2 of them be normal and 3 of them be exotic. Prompt one line per category starting with the question number such as: "1. Geograpyh (Normal)"',
        max_tokens: 100,
        temperature: 1
      })
    })
    .then(response => response.json())
    .then(data => {
      // Hide spinner
      spinner.style.display = 'none';

      // Create buttons for each category and add them to the page
      const categoryButtons = document.getElementById('category-buttons');

      data.choices[0].text.trim().split('\n').forEach(category => {
        const button = document.createElement('button');
        button.classList.add('btn', 'btn-primary', 'rounded-pill');
        button.innerText = category.trim();
        button.style.margin = '0 auto';
        button.style.marginTop = '10px';
        button.style.display = 'block';
        categoryButtons.appendChild(button);

        // Add event listener to button
        button.addEventListener('click', function() {
          // Hide the category-buttons div and show the spinner div
          const categoryButtons = document.querySelector('#category-buttons');
          const spinner = document.querySelector('#spinner');
          categoryButtons.style.display = 'none';
          spinner.style.display = 'block';

          // Make AJAX call to update action with category title as parameter
          const categoryName = encodeURIComponent(category.slice(3));
          const questionId = window.location.pathname.split('/').pop();
          fetch(`${questionId}?category=${categoryName}`, {
            method: 'PATCH',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': Rails.csrfToken()
            },
            body: JSON.stringify({})
          })
          .then(response => response.json())
          .then(data => {
            window.location.href = data.url;
          })
          .catch(error => console.error(error));
        });
      });
    })
    .catch(error => console.error(error));
  }
}

$(document).ready(function() {
  $('#new-round-modal').on('shown.bs.modal', function() {
    $('#round_name').focus();
  });

  $('#new-round-modal').on('hidden.bs.modal', function() {
    $(this).find('form')[0].reset();
  });

  // Call displayCategories function when the page loads
  window.addEventListener('turbo:load', displayCategories);
});
