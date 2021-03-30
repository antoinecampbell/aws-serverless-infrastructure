import http from 'k6/http';
import {check, sleep} from 'k6';

export const options = {
  thresholds: {
    http_req_failed: ['rate<0.01'],   // http errors should be less than 1%
    http_req_duration: ['p(95)<250'], // 95% of requests should be below 250ms
  }
}

export default function () {
  const response = http.get(`${__ENV.URL}` || 'http://test.k6.io');
  check(response, {'status was 200': (r) => r.status == 200});
  // sleep(1);
}
