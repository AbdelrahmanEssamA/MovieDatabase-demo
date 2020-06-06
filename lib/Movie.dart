import 'package:flutter/material.dart';
class Movie{
  var title;
  var id;
  var poster;
  var overview;
  var vote;
  var cover;
  var date;
  Movie(this.vote, this.title,this.overview, this.date);
  void setPoster(poster){
    this.poster=poster;
  }
    void setCover(cover){
    this.cover=cover;
  }

}
