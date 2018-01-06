makeVector <- function(x = numeric()) { #makeVetor를 일단 숫자벡터 값만을 입력 받는 
        #x라는 argument를 활용하는 새 함수로 선언. numeric()은 길이가 0인 숫자 벡터, 즉 빈 숫자 벡터.
        #입력받은 숫자벡터를 x에 바로 할당.
        m <- NULL #일단 m이란 변수를 선언, NULL을 할당.
        set <- function(y) { #y란 argument를 쓰는 함수 set을 선언. 
                x <<- y #set함수는 환경변수인 set안의 y값을 상위의 전역변수인 x에 할당함.
                m <<- NULL #set함수는 환경변수인 set 안의 NULL값을 상위의 전역변수인 m에 할당함.
        }
        get <- function() x #x값을 가져오는 함수 get을 선언. 가져와서 어디에 저장하는 건 아님. 
        #그냥 x값을 함수 실행시에 실시간으로 가져오는 것. 
        setmean <- function(mean) m <<- mean #mean이라는 argument를 입력받아서 전역변수 m에 할당하는 
        #setmean이라는 함수를 선언.
        getmean <- function() m #함수 실행시에 m값을 실시간으로 가져오는 함수 getmean을 선언.
        list(set = set, get = get, #set, get, setmean, getmean 4개에 함수에 각각의 이름을 할당해서
             setmean = setmean, #함수의 리스트를 만들어서 list명으로 함수를 호출할 수 있게 한다.
             getmean = getmean)
}
#결과적으로 makeVector를 이용하여 특정한 숫자 벡터열을 특정한 변수값에 할당하면,
#할당된 변수값은 4개의 하위함수의 집합으로 구성이 된다.
#set함수는 y로 입력되는 vector 값을 (1) x에 새로 덮어씌우고, (2) 저장된 m(평균)을 리셋한다.
#get함수는 x값을 가져온다.
#setmean함수는 mean값을 입력받아서 m값에 저장한다.
#getmean함수는 m값을 가져온다.
#x와 m은 어디에 들어있는가? -> makeVector로 생성된 변수 안의 x값, m값에 저장된다.
#하지만 이 x와 m을 직접 호출할 수는 없다. list의 원소나 구성요소로 지정된 게 아니기 때문.
#makeVector로 만든 값(값+함수4)은 전역변수로 지정이 되어 메모리에 올라간다. 
#따라서 위의 네 하위함수를 해당 변수차원에서 실행할 경우, 이들의 실행영역은 순간 생겼다 사라지는 
#로컬영역이지만, 이들의 결과값은 메모리에 올라가 있는 전역변수 값을 변경해버린다(<<-).
#해당 전역 환경에서 돌아가는 새로운 함수 또한 makeVector로 만들어진 전역변수 하위의 함수(메모리에 있는)
#를 호출하여 전역변수의 값을 고칠 수 있다.
#아래 cachemean은 위의 makevector로 만들어진 함수를 호출하여, makevector의 값을 점검하고 변경하는 함수다.
#이 함수는 앞서 생성한 전역변수명을 argument로 받아서, 그 전역변수 내의 하위함수들을 불러오거나 작동시킨다.

cachemean <- function(x, ...) {
        m <- x$getmean() #여기서의 m은 cachemean 내의 로컬변수로 전역변수 안의 m과 다르다.
        #먼저 입력받은 전역변수의 getmean()함수를 활용, 저장된 mean(전역의 m)값을 가져와 m에 할당한 후,
        if(!is.null(m)) { #m이 null인지 확인함을 통해 전역변수의 mean(m)이 비었는지 확인해서 아니면,
                message("getting cached data") #저장된 데이터를 가져온다는 메시지를 출력한 뒤
                return(m) #m값을 함수의 최종값으로 되돌린다. = 전역m값을 로컬m으로 가져와서 출력함.
        } #로컬m이 null이면=전역m이 null이면,
        data <- x$get() #전역의 get()함수로 전역의 벡터를 data란 로컬변수로 가져온 뒤
        m <- mean(data, ...) #로컬 data와 추가 입력받은 값(필요하면)의 평균을 내서 로컬m에 할당하고
        x$setmean(m)#로컬m값을 전역의 setmean()함수를 활용하여 전역의 m값에 저장한 다음
        m #로컬의 m값을 출력한다.
}

#종합적으로, makeVector는 전역변수를 만들고, 그 전역변수 값을 가져와서 확인하고, 고쳐쓰는 4가지 함수를 만들며,
#cachemean은 makevector로 만들어진 전역변수를 이용하여 평균을 가져오거나, 없으면 만들고 전역에 저장한다.