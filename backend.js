const AWS = require("aws-sdk");

const makeS3WithRole = (roleArn) => {
	const credentials = new AWS.ChainableTemporaryCredentials({params: {RoleArn: roleArn}});
	credentials.expiryWindow = 15 * 60;
	
	return new AWS.S3({credentials, signatureVersion: "v4"});
};

module.exports.handler = async (event) => {

	const pathPattern = /^\/role\/(?<roleNum>\d+)\/bucket\/(?<bucketNum>\d+)$/;

	if (event.path === "/") {
		return {
			statusCode: 200,
			headers: {
				"Content-Type": "text/html",
			},
			body: `
<html>
	<head><style>img {max-width: 150px; max-height:150px;}</style></head>
	<body><table>
	<thead>
		<tr>
			<th></th>
			<th>Role1</th>
			<th>Role2</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Bucket1</td>
			<td><img src="role/1/bucket/1" alt=""></td>
			<td><img src="role/2/bucket/1" alt=""></td>
		</tr>
		<tr>
			<td>Bucket2</td>
			<td><img src="role/1/bucket/2" alt=""></td>
			<td><img src="role/2/bucket/2" alt=""></td>
		</tr>
	</tbody>
</table></body>
</html>
			`,
		};
	} else if (event.path.match(pathPattern)) {
		const {roleNum, bucketNum} = event.path.match(pathPattern).groups;
		const s3 = makeS3WithRole(roleNum === "1" ? process.env.ROLE_1 : process.env.ROLE_2);
		const bucket = bucketNum === "1" ? process.env.BUCKET_1 : process.env.BUCKET_2;

		const url = await s3.getSignedUrlPromise(
			"getObject",
			{
				Bucket: bucket,
				Key: "cat.jpg"
			}
		);

		return {
			statusCode: 307,
			headers: {
				Location: url,
			},
		};
	}else {
		return {
			statusCode: 404,
		};
	}
};

