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
    public class ITHeadController : ApiController
    {
        private String constr = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SocietySync;Data Source=SAAD\\VE_SERVER";
        private SqlConnection con = null;
        private SqlCommand cmd = null;

        [HttpGet]
        [Route("IT_summary")]
        public async Task<IHttpActionResult> it_summary()
        {
            // http://192.168.4.135:5000/IT_summary
            SummaryCard it_summary = new SummaryCard();

            con = new SqlConnection(constr);
            con.Open();

            String query = "SELECT top 3 e_name FROM Requisitions WHERE student_affairs_action = 'accepted' and account_office_action = 'accepted' and CONVERT(DATE, e_date) = CONVERT(DATE, GETDATE());";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = cmd.ExecuteReader();

            if (sdr.Read()) it_summary.n1 = sdr["e_name"].ToString();
            if (sdr.Read()) it_summary.n2 = sdr["e_name"].ToString();
            if (sdr.Read()) it_summary.n3 = sdr["e_name"].ToString();

            sdr.Close();

            query = "select e_name , e_date from  Requisitions where student_affairs_action = 'accepted' and account_office_action = 'accepted'";
            cmd = new SqlCommand(query, con);
            sdr = await cmd.ExecuteReaderAsync();

            int total = 0;
            int today = 0;
            int tomorrow = 0;

            DateTime today_date = DateTime.Now.Date;
            DateTime tomorrow_date = today_date.Date.AddDays(1);

            while (sdr.Read())
            {
                total++;

                if (DateTime.Parse(sdr["e_date"].ToString().Trim()) == today_date)
                {
                    today++;
                }
                else if (DateTime.Parse(sdr["e_date"].ToString().Trim()) == tomorrow_date)
                {
                    tomorrow++;
                }
            }

            it_summary.total = total.ToString();
            it_summary.today = today.ToString();
            it_summary.tomorrow = tomorrow.ToString();
            con.Close();
            return Ok(it_summary);
        }


        [HttpGet]
        [Route("IT_detail")]
        public async Task<IHttpActionResult> it_full(String r_id)
        {
            // http://192.168.4.135:5000/IT_detail?r_id=3

            con = new SqlConnection(constr);
            con.Open();

            ITDetails it_detail = new ITDetails();

            String query = "select society, e_name, e_venu,e_date, e_time_from, e_time_to, e_type," +
                " it_req_main, it_req_other from Requisitions where r_id = " + r_id;

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                it_detail.society = sdr["society"].ToString();
                it_detail.e_name = sdr["e_name"].ToString();
                it_detail.e_venu = sdr["e_venu"].ToString();
                it_detail.e_date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();
                it_detail.e_time_from = DateTime.Parse(sdr["e_time_from"].ToString()).TimeOfDay.ToString();
                it_detail.e_time_to = DateTime.Parse(sdr["e_time_to"].ToString()).TimeOfDay.ToString();
                it_detail.e_type = sdr["e_type"].ToString();
                it_detail.it_requirments_main = sdr["it_req_main"].ToString();
                it_detail.it_requirments_other = sdr["it_req_other"].ToString();
            }
            con.Close();
            return Ok(it_detail);
        }


        [HttpGet]
        [Route("IT_req_pending")]
        public async Task<IHttpActionResult> it_pending()
        {
            // http://192.168.4.135:5000/IT_req_pending
            con = new SqlConnection(constr);
            con.Open();

            List<ITView> list_ITPending = new List<ITView>();

            String query = "SELECT r_id, e_name , e_date FROM Requisitions WHERE " +
                "student_affairs_action = 'accepted' and account_office_action = 'accepted' " +
                "and CONVERT(DATE, e_date) >= CONVERT(DATE, GETDATE());";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                ITView af = new ITView();
                af.r_id = sdr["r_id"].ToString();
                af.e_name = sdr["e_name"].ToString();
                af.date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();

                list_ITPending.Add(af);
            }
            con.Close();
            return Ok(list_ITPending);
        }

        [HttpGet]
        [Route("IT_req_completed")]
        public async Task<IHttpActionResult> it_completed()
        {
            // http://192.168.4.135:5000/IT_req_completed
            con = new SqlConnection(constr);
            con.Open();

            List<ITView> list_ITCompleted = new List<ITView>();

            String query = "SELECT r_id, e_name , e_date FROM Requisitions WHERE " +
                "student_affairs_action = 'accepted' and account_office_action = 'accepted' " +
                "and CONVERT(DATE, e_date) < CONVERT(DATE, GETDATE());";

            cmd = new SqlCommand(query, con);
            SqlDataReader sdr = await cmd.ExecuteReaderAsync();

            while (sdr.Read())
            {
                ITView af = new ITView();
                af.r_id = sdr["r_id"].ToString();
                af.e_name = sdr["e_name"].ToString();
                af.date = DateTime.Parse(sdr["e_date"].ToString()).ToShortDateString();

                list_ITCompleted.Add(af);
            }
            con.Close();
            return Ok(list_ITCompleted);
        }
    }

    public class ITDetails
    {
        public String society { get; set; }
        public String e_name { get; set; }
        public String e_venu { get; set; }
        public String e_date { get; set; }
        public String e_time_from { get; set; }
        public String e_time_to { get; set; }
        public String e_type { get; set; }
        public String it_requirments_main { get; set; }
        public String it_requirments_other { get; set; }
    }

    public class ITView
    {
        public String r_id { set; get; }
        public String e_name { set; get; }
        public String date { set; get; }
    }

    public class SummaryCard
    {
        public String n1 { get; set; }
        public String n2 { get; set; }
        public String n3 { get; set; }
        public String total { get; set; }
        public String today { get; set; }
        public String tomorrow { get; set; }
    }
}
