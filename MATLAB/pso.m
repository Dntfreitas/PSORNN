function pso(net, hiddenLayerSize, ninputs, trainX, trainT, testX, testT)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ndimension = 1 + hiddenLayerSize*(2 + ninputs); % Number of dimensions
nparticles = 25; % Number of particles
maxiterations = 5000;
ninputs = 2; % Number of inputs
blo = -10;
bup = 10;

%% Initialization
% Initialize the particles' position 
x = initWeigths(ninputs, ndimension, nparticles);
% Initialize the particles' best known position to its initial position
p = x;
%  Initialize the global best known position
[~, pos] = min(f(net, hiddenLayerSize, trainX, trainT, ninputs, x));
g = x(:, pos);
% Initialize the particles velocity
v = init_velocity(-abs(blo-bup), abs(blo-bup), ndimension, nparticles);

%% Main loop
for i = 1:maxiterations
    v = compute_velocity(x, p, g, v);
    x = x + v;
    % Get the particles' best known position
    [p, g] = compute_p_best(x, p, g, net, hiddenLayerSize, trainX, trainT, ninputs);
end
f(net, hiddenLayerSize, trainX, trainT, ninputs, g)
f(net, hiddenLayerSize, testX, testT, ninputs, g)

end

function [p_next, g_next] = compute_p_best(x, p, g, net, hiddenLayerSize, trainX, trainT, ninputs)
    fx = f(net, hiddenLayerSize, trainX, trainT, ninputs, x);
    fp = f(net, hiddenLayerSize, trainX, trainT, ninputs, p);
    fg = f(net, hiddenLayerSize, trainX, trainT, ninputs, g);  
    [~, n] = size(x);
    for i = 1:n
       if fx(:,i) < fp(:,i)
           p(:, i) = x(:, i);
           if fp(:,i) < fg
               g = p(:, i);
           end
       end
     end
   p_next = p;
   g_next = g;
end

function [v_next] = compute_velocity(x, p, g, v)
    inertia = 0.9;
    phip = 0.5;
    phig = 0.3;
    
    [d, n] = size(x);
    
    for i = 1:d
       for d = 1: n
           rp = rand();
           rg = rand();
           v(i, d) = inertia * v(i, d) + phip * rp * (p(i, d) - x(i, d)) + phig * rg * (g(i) - x(i, d));
       end
    end
   v_next = v;
end

function [v] = init_velocity(blo, bup, ndimension, nparticles)
    v = blo + (bup-blo).*rand(ndimension, nparticles);
end

function [r] = f(net, hiddenLayerSize, trainX, trainT, ninputs, x)

    [~, n] = size(x);
    
    r = zeros(1, n); 
    
    for i = 1:n
        
        spl1 = 1:numel(net.IW{1,1});
        spl2 = spl1(end)+1:spl1(end)+numel(net.LW{2,1});
        spl3 = spl2(end)+1:spl2(end)+numel(net.b{1,1});
        
        IW = reshape(x(spl1,i), size(net.IW{1,1}));
        LW = reshape(x(spl2,i), size(net.LW{2,1})); 
        b1 = reshape(x(spl3,i), size(net.b{1,1}));
        b2 = x(end,i);
                
        net.IW{1,1} = IW; 
        net.LW{2,1} = LW;
        net.b{1,1}  = b1;
        net.b{2,1}  = b2;
        
        % Test the network and compute metrics
        y = net(trainX');
        e = gsubtract(trainT',y);
        r(i) = mse(e);
        
    end
    
end
