use serde::{Deserialize, Serialize};
use mongodb::bson::DateTime;
use bson::oid::ObjectId;

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct Evaluation {
    pub tournamentName: String,
    pub roundName: String,
    pub isPrelim: bool,
    pub isImprovement: bool,
    pub decision: f32,
    pub comparison: f32,
    pub citation: f32,
    pub coverage: f32,
    pub bias: f32,
    pub weight: f32,
    pub date: DateTime
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct Paradigm {
    pub nationality: String,
    pub gender: String,
    pub age: String,
    pub university: String
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct Judge {
    pub _id: ObjectId,
    pub name: String,
    pub email: String,
    pub evaluations: Vec<Evaluation>,
    pub options: Paradigm
}
