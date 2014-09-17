using PayLoad.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Helpers;
using System.Web.Http;

namespace PayLoad.Controllers
{
    public class PayLoadController : ApiController
    {
        // POST api/payload
        public HttpResponseMessage Post([FromBody] object value)
        {
            if (value != null)
            {
                try
                {
                    Payloads payloads = Json.Decode(value.ToString(), typeof(Payloads));

                    if (payloads != null && payloads.payload != null)
                    {
                        Responses responses = new Responses { response = new List<Response>() };

                        payloads.payload.ForEach(p =>
                        {
                            if ((p.drm ?? false) && p.episodeCount != null && p.episodeCount > 0)
                            {
                                responses.response.Add(new Response { 
                                    image = p.image != null ? p.image.showImage : string.Empty, 
                                    slug = p.slug, 
                                    title = p.title
                                });
                            }
                        });

                        return Request.CreateResponse(HttpStatusCode.OK, responses, "application/json");
                    }
                }
                catch (ArgumentException ex)
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, new BadRequest { error = string.Format("Could not decode request: {0}", ex.Message) }, "application/json");
                }
            }

            return Request.CreateResponse(HttpStatusCode.BadRequest, new BadRequest { error = "Could not decode request: JSON parsing failed" }, "application/json");
        }
    }
}
