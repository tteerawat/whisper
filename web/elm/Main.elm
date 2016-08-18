module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy)
import Html.App as App
import Http
import Json.Decode as Json exposing (..)
import Task
import String exposing (toLower, contains, trim)


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- model


type Status
    = NoOp
    | Processing


type alias Post =
    { title : String
    , url : String
    , favorite : Bool
    }


type alias Model =
    { posts : List Post
    , keyword : String
    , status : Status
    }


init : ( Model, Cmd Msg )
init =
    ( { posts = []
      , keyword = ""
      , status = Processing
      }
    , fetchPosts
    )


filterPosts : String -> List Post -> List Post
filterPosts keyword posts =
    let
        matchedPost post =
            contains (normalizeString keyword) (normalizeString post.title)
    in
        List.filter matchedPost posts



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
            ( { model | posts = posts, status = NoOp }, Cmd.none )

        FetchFail error ->
            ( model, fetchPosts )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- view


header : Html Msg
header =
    h2 [ style [ ( "margin-bottom", "20px" ) ] ] [ text "Listing posts" ]


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
        [ td [] [ i [ class (postIcon post) ] [] ]
        , td [] [ a [ href post.url, target "_blank" ] [ text post.title ] ]
        , td [] [ text post.url ]
        ]


postsHeader : Html Msg
postsHeader =
    thead
        []
        [ tr
            []
            [ th [] []
            , th [] [ text "Title" ]
            , th [] [ text "Url" ]
            ]
        ]


postsBody : List Post -> Html Msg
postsBody posts =
    tbody [] (List.map postInfo posts)


postsTable : Model -> Html Msg
postsTable model =
    let
        posts' =
            model.posts |> filterPosts model.keyword
    in
        table
            [ class "table table-striped" ]
            [ postsHeader
            , lazy postsBody posts'
            ]


spinner : Html Msg
spinner =
    let
        style' =
            [ ( "margin-top", "60px" ), ( "margin-bottom", "60px" ) ]
    in
        div
            [ class "text-center", style style' ]
            [ i [ class "fa fa-refresh fa-spin fa-3x fa-fw" ] [] ]


view : Model -> Html Msg
view model =
    let
        content =
            if model.status == Processing then
                spinner
            else
                postsTable model
    in
        div
            []
            [ header
            , searchBar
            , content
            ]



-- utils


postIcon : Post -> String
postIcon post =
    if post.favorite then
        "fa fa-heart heart"
    else
        "fa fa-heart-o"


normalizeString : String -> String
normalizeString str =
    str |> trim |> toLower



-- Http


fetchPosts : Cmd Msg
fetchPosts =
    let
        url =
            "/api/posts"
    in
        Task.perform FetchFail FetchSucceed (Http.get decodePosts url)


decodePost : Decoder Post
decodePost =
    object3 Post
        ("title" := string)
        ("url" := string)
        ("favorite" := bool)


decodePosts : Decoder (List Post)
decodePosts =
    Json.list decodePost
