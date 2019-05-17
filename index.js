const express = require("express");
const AWS = require("aws-sdk");

const {BUCKETNAME_1, BUCKETNAME_2, ROLEARN_1, ROLEARN_2} = process.env;

const makeS3WithRole = (roleArn) => {
	const credentials = new AWS.ChainableTemporaryCredentials({params: {RoleArn: roleArn}});
	credentials.expiryWindow = 15 * 60;
	
	return new AWS.S3({credentials});
};

const s3role1 = makeS3WithRole(ROLEARN_1);
const s3role2 = makeS3WithRole(ROLEARN_2);

const app = express();

app.set("view engine", "pug");

app.get("/", (req, res) => {
	res.render("index");
});

app.get("/role/:roleNum/bucket/:bucketNum", (req, res) => {
	const s3 = req.params.roleNum === "1" ? s3role1 : s3role2;
	const bucket = req.params.bucketNum === "1" ? BUCKETNAME_1 : BUCKETNAME_2;

	s3.config.credentials.getPromise().then(() => {
		const url = s3.getSignedUrl(
			"getObject",
			{
				Bucket: bucket,
				Key: "cat.jpg"
			}
		);

		res.redirect(307, url);
	});
});

app.listen(3000);
