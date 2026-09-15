# HCP Terraform Interview Demo — Setup Steps

Total setup time if you do it the night before: ~20 minutes. Do NOT try to
set this up live during your interview — pre-stage everything.

## 1. Create the AWS credentials HCP Terraform will use

1. In your AWS trial account, go to IAM → Users → create a user
   `hcp-terraform-demo` with programmatic access only.
2. Attach a scoped policy (don't use full AdministratorAccess) — at minimum
   `AmazonS3FullAccess` is enough for this demo.
3. Save the Access Key ID and Secret Access Key — you'll paste these into
   HCP Terraform as workspace variables, not into any file.

## 2. Push this code to GitHub

1. Create a new **public or private** repo, e.g. `terraform-demo`.
2. Copy `main.tf`, `variables.tf`, `outputs.tf` into the repo root.
3. Commit and push to `main`.
4. Keep the `policies/` folder as a **separate** repo (Sentinel policy sets
   are usually connected as their own VCS repo in HCP Terraform) — see step 5.

## 3. Create your HCP Terraform org and workspace

1. Sign up / log in at https://app.terraform.io (free tier, no card needed).
2. Create an organization if you don't have one.
3. New Workspace → **Version control workflow** → connect your GitHub
   account → select the `terraform-demo` repo.
4. Name the workspace `terraform-demo` — this must match the `workspaces {
   name = "terraform-demo" }` block in `main.tf`.
5. In workspace Settings → General, confirm the Terraform version is
   >= 1.5.0.

## 4. Add AWS credentials as workspace variables

In the workspace → Variables → add these as **Environment variables**,
marking both as **Sensitive**:

| Key                     | Value                  |
|--------------------------|-------------------------|
| `AWS_ACCESS_KEY_ID`      | (your access key)       |
| `AWS_SECRET_ACCESS_KEY`  | (your secret key)       |

## 5. Add the Sentinel policy set

1. Push the `policies/` folder to its own small repo, e.g.
   `terraform-demo-policies`.
2. In HCP Terraform, go to your organization Settings → Policy Sets →
   Connect a new policy set.
3. Choose **Sentinel**, connect the `terraform-demo-policies` repo, point it
   at `sentinel.hcl` in the root.
4. Scope it to your `terraform-demo` workspace (or all workspaces).

## 6. Run it

1. Back in the `terraform-demo` workspace, click **Start new run** (or just
   push a commit — VCS-driven runs trigger automatically).
2. Watch the **Plan** stage, then the **Policy Check** stage — both
   Sentinel policies should pass since `main.tf` already blocks public
   access and sets both tags.
3. Click **Confirm & Apply**.
4. Show the resulting state in the workspace's **States** tab.

## 7. Live "governance moment" — trigger a policy failure on purpose

Right before the interview, prepare (but don't commit yet) a second branch
or a local edit that:
- Removes the `Owner` tag from `aws_s3_bucket.demo`, **or**
- Comments out the `aws_s3_bucket_public_access_block` resource entirely.

During the demo, push that change (or open the PR) to show a run that gets
flagged or hard-blocked by policy — this is the moment that actually lands
with an interviewer, since it shows *why* teams pay for this over raw
Terraform CLI.

## 8. Clean up afterward

`terraform destroy` from the workspace (Settings → Destruction and
Deletion → Queue destroy plan) so you don't leave an orphaned bucket in
your trial AWS account.
