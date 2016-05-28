module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App
import Http
import Json.Decode as Json exposing (..)
import Task
import String exposing (toLower, contains)


main =
  App.program
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- model


type alias Post =
  { title    : String
  , url      : String
  , favorite : Bool
  }


type alias Model =
  { posts   : List Post
  , keyword : String
  }


init : ( Model, Cmd Msg )
init =
  ( { posts = [], keyword = "" }
  , fetchPosts
  )


filterPosts : String -> List Post -> List Post
filterPosts keyword posts =
  posts
    |> List.filter ( \post -> contains (toLower keyword) (toLower post.title) )



-- update


type Msg
  = Search String
  | FetchSucceed (List Post)
  | FetchFail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Search keyword ->
      ( { model | keyword = keyword }, Cmd.none )

    FetchSucceed posts ->
      ( { model | posts = posts }, Cmd.none )

    FetchFail error ->
      ( model, fetchPosts )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- view


header : Html Msg
header = h2 [] [ text "Listing posts" ]


searchBar : Html Msg
searchBar =
  div
    [ class "input-group-lg" ]
    [ input
      [ type' "text"
      , class "form-control"
      , placeholder "Search..."
      , onInput Search
      ]
      []
    ]


postInfo : Post -> Html Msg
postInfo post =
  tr
    []
    [ td [] [ i [ class (postIcon post) ] [ ] ]

    , td [] [ a [ href post.url, target "_blank" ] [ text post.title ] ]

    , td [] [ text post.url ]
    ]


postsTable : Model -> Html Msg
postsTable model =
  table
    [ class "table table-striped" ]
    [ thead
        []
        [ tr
            []
            [ th [] []
            , th [] [ text "Title" ]
            , th [] [ text "Url" ]
            ]
        ]

    , tbody
        []
        ( model.posts
            |> filterPosts model.keyword
            |> List.map ( \post -> postInfo post ) )
    ]


view : Model -> Html Msg
view model =
  div
    [ class "main" ]
    [ header
    , br [] []
    , searchBar
    , postsTable model
    ]



-- utils


postIcon : Post -> String
postIcon post =
  if post.favorite then "fa fa-heart heart" else "fa fa-heart-o"



-- Http


fetchPosts : Cmd Msg
fetchPosts =
  let url = "/api/posts"
  in Task.perform FetchFail FetchSucceed (Http.get decodePosts url)


decodePost : Decoder Post
decodePost =
  object3 Post
    ("title" := string)
    ("url" := string)
    ("favorite" := bool)


decodePosts : Decoder (List Post)
decodePosts =
  Json.list decodePost
