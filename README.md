# PlayingWithJSON

Quick project done as an exercise:

- Fetches JSON from 500px.com's API
- Parses JSON and stores image urls and detail urls in an array
- Loads and displays images in a collection view

For the purposes of the exercise, no external frameworks were used.
Using frameworks like AlamoFire, SwiftyJSON and Kingfisher for fetching, parsing and image loading could simplify the code considerably.

Object handling is currently very minimalistic - URLs parsed from the fetched JSON are stored in dictionaries; a custom model object would likely be more appropriate for actual usage.

Image handling is also very naive - no caching mechanism is currently in place and that represents an obvious opportunity for improvement.

Enhancements in the user experience are also possible; for example, enabling users to tap on an image to get more details.  In addition, there are no user-facing alerts in place to notify users in the case of an error such as a network connection issue or a parsing error due to i.e. a change in the API.  

Finally, the project currently lacks Unit Tests and UI Tests.


