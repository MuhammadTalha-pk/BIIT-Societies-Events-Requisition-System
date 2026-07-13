using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;

namespace SocietyRecognitions.Controllers
{
    public class AccountOfficeController : ApiController
    {
        private String constr = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SocietySync;Data Source=SAAD\\VE_SERVER";
        private SqlConnection con = null;
        private SqlCommand cmd = null;

        // Get the records for accounts office in the Review Section
        [HttpGet]
        [Route("Accounts_req_prev")]
        public async Task<IHttpActionResult> Accounts_prev()
        {
            // http://192.168.4.135:5000/Accounts_req_prev
            con = new SqlConnection(constr);
            con.Open();

            List<AccountsHalf> list_half_accounts = new List<AccountsHalf>();

            String query = "select r_id, e_name, e_date from Requisitions where student_affairs_action = 'accepted' and account_office_action = ''";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                AccountsHalf af = new AccountsHalf();
                af.r_id = sdr["r_id"].ToString();
                af.e_name = sdr["e_name"].ToString();
                af.date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();

                list_half_accounts.Add(af);
            }
            con.Close();
            return Ok(list_half_accounts);
        }

        // After clicking on the event in the Review Section, open a new screen and show the below data
        [HttpGet]
        [Route("Accounts_req_detail")]
        public async Task<IHttpActionResult> Accounts_detail(String r_id)
        {
            // http://192.168.4.135:5000/Accounts_req_detail?r_id=3

            con = new SqlConnection(constr);
            con.Open();

            AccountsFull acc_req = new AccountsFull();

            String query = "select u_id,r_id, society, e_name, e_venu,e_budget ,e_date, e_time_from, e_time_to, e_type," +
                " staff_req_main,staff_req_other, it_req_main, it_req_other, student_affairs_comments" +
                ", e_description from Requisitions where student_affairs_action = 'accepted' and r_id = " + r_id;

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            SqlConnection con2 = new SqlConnection(constr);
            con2.Open();

            while (sdr.Read())
            {
                String id = sdr["u_id"].ToString();
                String u_query = "select name from User1 where id= " + id;
                SqlCommand cmd2 = new SqlCommand(u_query, con2);
                SqlDataReader sdr2 = await cmd2.ExecuteReaderAsync();
                if (sdr2.Read())
                {
                    acc_req.username = sdr2["name"].ToString();
                    sdr2.Close();
                }

                acc_req.r_id = sdr["r_id"].ToString();
                acc_req.society = sdr["society"].ToString();
                acc_req.e_name = sdr["e_name"].ToString();
                acc_req.e_venu = sdr["e_venu"].ToString();
                acc_req.budget = sdr["e_budget"].ToString();
                acc_req.e_date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();
                acc_req.e_time_from = DateTime.Parse(sdr["e_time_from"].ToString()).TimeOfDay.ToString();
                acc_req.e_time_to = DateTime.Parse(sdr["e_time_to"].ToString()).TimeOfDay.ToString();
                acc_req.e_type = sdr["e_type"].ToString();
                acc_req.staff_req_main = sdr["staff_req_main"].ToString();
                acc_req.staff_req_other = sdr["staff_req_other"].ToString();
                acc_req.it_req_main = sdr["it_req_main"].ToString();
                acc_req.it_req_other = sdr["it_req_other"].ToString();
                acc_req.student_affairs_comments = sdr["student_affairs_comments"].ToString();
                acc_req.e_description = sdr["e_description"].ToString();
            }
            con.Close();
            return Ok(acc_req);
        }

        // After clicking on the event in the Review Section, open a new screen and show the below data
        // with student affairs comments and account office comments
        [HttpGet]
        [Route("Accounts_req_full")]
        public async Task<IHttpActionResult> Accounts_full(String r_id)
        {
            // http://192.168.4.135:5000/Accounts_req_full?r_id=3

            con = new SqlConnection(constr);
            con.Open();

            AccountsFull acc_req = new AccountsFull();

            String query = "select u_id,r_id, society, e_name, e_venu,e_budget ,e_date, e_time_from, e_time_to, e_type," +
                " staff_req_main,staff_req_other, it_req_main, it_req_other, student_affairs_comments, account_office_comments " +
                ", e_description from Requisitions where student_affairs_action = 'accepted' and r_id = " + r_id;

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            SqlConnection con2 = new SqlConnection(constr);
            con2.Open();

            while (sdr.Read())
            {
                String id = sdr["u_id"].ToString();
                String u_query = "select name from User1 where id= " + id;
                SqlCommand cmd2 = new SqlCommand(u_query, con2);
                SqlDataReader sdr2 = cmd2.ExecuteReader();
                if (sdr2.Read())
                {
                    acc_req.username = sdr2["name"].ToString();
                    sdr2.Close();
                }

                acc_req.r_id = sdr["r_id"].ToString();
                acc_req.society = sdr["society"].ToString();
                acc_req.e_name = sdr["e_name"].ToString();
                acc_req.e_venu = sdr["e_venu"].ToString();
                acc_req.budget = sdr["e_budget"].ToString();
                acc_req.e_date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();
                acc_req.e_time_from = DateTime.Parse(sdr["e_time_from"].ToString()).TimeOfDay.ToString();
                acc_req.e_time_to = DateTime.Parse(sdr["e_time_to"].ToString()).TimeOfDay.ToString();
                acc_req.e_type = sdr["e_type"].ToString();
                acc_req.staff_req_main = sdr["staff_req_main"].ToString();
                acc_req.staff_req_other = sdr["staff_req_other"].ToString();
                acc_req.it_req_main = sdr["it_req_main"].ToString();
                acc_req.it_req_other = sdr["it_req_other"].ToString();
                acc_req.student_affairs_comments = sdr["student_affairs_comments"].ToString();
                acc_req.account_office_comments = sdr["account_office_comments"].ToString();
                acc_req.e_description = sdr["e_description"].ToString();
            }
            con.Close();
            return Ok(acc_req);
        }



        // accepted or rejected account_office_action 
        [HttpPost]
        [Route("acc_mark_status")]
        public async Task<IHttpActionResult> acc_mark_status([FromBody] AccStatusMark sm)
        {
            //http://192.168.4.135:5000/acc_mark_status
            con = new SqlConnection(constr);
            con.Open();

            String query = $"update Requisitions set account_office_action = '{sm.status}' , account_office_comments = '{sm.account_office_comments}' " +
                $" where r_id = {sm.r_id} and student_affairs_action = 'accepted'";

            cmd = new SqlCommand(query, con);
            int count = await cmd.ExecuteNonQueryAsync();
            con.Close();
            if (count > 0)
            {
                return Ok("Status changed Sucessfully");
            }
            else
            {
                return InternalServerError(new Exception("Failed to update status."));
            }
        }


        // open the Approved section to see all the accepted Events
        [HttpGet]
        [Route("accepted_accounts")]
        public async Task<IHttpActionResult> accepted_accounts()
        {
            // http://192.168.4.135:5000/accepted_accounts
            con = new SqlConnection(constr);
            con.Open();

            List<AffairsHalf> acc_affairs = new List<AffairsHalf>();

            String query = "select r_id, e_name, e_date from Requisitions where student_affairs_action = 'accepted' and account_office_action = 'accepted'";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                AffairsHalf af = new AffairsHalf();
                af.r_id = sdr["r_id"].ToString();
                af.e_name = sdr["e_name"].ToString();
                af.date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();

                acc_affairs.Add(af);
            }
            con.Close();
            return Ok(acc_affairs);
        }

        // open the Rejected section to see all the rejected Events
        [HttpGet]
        [Route("rejected_accounts")]
        public async Task<IHttpActionResult> rejected_rejected()
        {
            // http://192.168.4.135:5000/rejected_accounts
            con = new SqlConnection(constr);
            con.Open();

            List<AffairsHalf> acc_affairs = new List<AffairsHalf>();

            String query = "select r_id,e_name, e_date from Requisitions where student_affairs_action = 'accepted' and account_office_action = 'rejected'";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                AffairsHalf af = new AffairsHalf();
                af.r_id = sdr["r_id"].ToString();
                af.e_name = sdr["e_name"].ToString();
                af.date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();

                acc_affairs.Add(af);
            }
            con.Close();
            return Ok(acc_affairs);
        }
        [HttpGet]
        [Route("rejected_amount")]
        public async Task<IHttpActionResult> rejected_amount(float amount)
        {
            // http://192.168.4.135:5000/rejected_accounts
            con = new SqlConnection(constr);
            con.Open();

            List<AffairsHalf> acc_affairs = new List<AffairsHalf>();

            String query = "select r_id,e_name, e_date ,e_budget from Requisitions where student_affairs_action = 'accepted' and account_office_action = 'rejected'";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {

                AffairsHalf af = new AffairsHalf();
                float am = float.Parse(sdr["budget"].ToString());
                am = am - amount;

                af.r_id = sdr["r_id"].ToString();
                af.e_name = sdr["e_name"].ToString();
                af.date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();
                af.budget = am;
                

                acc_affairs.Add(af);
            }
            con.Close();
            return Ok(acc_affairs);
        }


        // on the home page, you will see the top 3 names for pending Events
        // also you will see the count of approved, rejected and pending
        [HttpGet]
        [Route("accounts_summary")]
        public async Task<IHttpActionResult> accounts_summary()
        {
            // http://192.168.4.135:5000/accounts_summary
            RequisitionsRec rr = new RequisitionsRec();

            con = new SqlConnection(constr);
            con.Open();

            String query = "select top 3 e_name from Requisitions where student_affairs_action = 'accepted' and account_office_action=''";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            if (sdr.Read()) 
                rr.n1 = sdr["e_name"].ToString();
            if (sdr.Read()) 
                rr.n2 = sdr["e_name"].ToString();
            if (sdr.Read()) 
                rr.n3 = sdr["e_name"].ToString();

            sdr.Close();

            query = "select account_office_action from  Requisitions where student_affairs_action = 'accepted' ";
            cmd = new SqlCommand(query, con);
            sdr = cmd.ExecuteReader();

            int accepted = 0;
            int rejected = 0;
            int pending = 0;

            while (sdr.Read())
            {
                if (sdr["account_office_action"].ToString().Trim() == "accepted")
                {
                    accepted++;
                }
                else if (sdr["account_office_action"].ToString().Trim() == "rejected")
                {
                    rejected++;
                }
                else if (sdr["account_office_action"].ToString().Trim() == "")
                {
                    pending++;
                }
            }

            rr.rejected = rejected.ToString();
            rr.accepted = accepted.ToString();
            rr.pending = pending.ToString();
            con.Close();
            return Ok(rr);
        }
    }
    public class AccountsFull
    {
        public String r_id { get; set; }
        public String username { get; set; }
        public String society { get; set; }
        public String e_name { get; set; }
        public String e_venu { get; set; }
        public String budget { get; set; }
        public String e_date { get; set; }
        public String e_time_from { get; set; }
        public String e_time_to { get; set; }
        public String e_type { get; set; }
        public String staff_req_main { get; set; }
        public String staff_req_other { get; set; }
        public String it_req_main { get; set; }
        public String it_req_other { get; set; }
        public String student_affairs_comments { get;set; }
        public String account_office_comments { get; set; }
        public String e_description { get; set; }
    }

    public class AccountsHalf
    {
        public String r_id { set; get; }
        public String e_name { set; get; }
        public String date { set; get; }
        public float budget { set; get; }
    }

    public class RequisitionsRec
    {
        public String n1 { get; set; }
        public String n2 { get; set; }
        public String n3 { get; set; }
        public String accepted { get; set; }
        public String rejected { get; set; }
        public String pending { get; set; }
    }

    public class AccStatusMark
    {
        public String r_id { set; get; }
        public String status { set; get; } // status should only be accepted or rejected
        public String account_office_comments { set; get; }
    }
}
